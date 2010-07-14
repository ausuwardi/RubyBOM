require 'rubygems'
require 'active_record'
require 'unit.rb'
require 'item.rb'
require 'bomnode.rb'
require 'sequencelist.rb'
require 'libglade2'

$id = 0
$description = 1
$stock_buffer = 2
$mpoq = 3
$leadtime = 4

class CobaGlade
	TITLE = "Coba Glade"
	NAME = "CobaGlade"
	VERSION = "1.0"
	
	attr_reader :appwindow
	attr_reader :treeview
	attr :glade
	attr :current_item
	attr :editing_item
	
	def initialize(path)
		@glade = GladeXML.new(path) {|handler| method(handler)}
		@appwindow = @glade.get_widget("appwindow")
		
		@glade.get_widget("aboutDialog").transient_for = @appwindow
		
		@treeview = @glade.get_widget("treeview")
		
		@tblItemStore = nil
		setup_item_treeview()

		@treeview.selection.set_mode(Gtk::SELECTION_SINGLE)
		@treeview.selection.set_select_function {
			|selection, model, path, path_currently_selected|
				treeview_select_function(
					selection, model, path, path_currently_selected
				)
			}
		
		@cmbUnitStore = nil
		setup_units_combo()
		
		@editing_item = nil
	end
	
	# Setup Treeview
	def setup_item_treeview()
		# Create a new GtkCellRendererText, add it to the tree
		# view column and append the column to the tree view.
		renderer = Gtk::CellRendererText.new
		column = Gtk::TreeViewColumn.new("Id", renderer, "text" => $id)
		@treeview.append_column(column)
		renderer = Gtk::CellRendererText.new
		column = Gtk::TreeViewColumn.new("Description", renderer, "text" => $description)
		@treeview.append_column(column)
		renderer = Gtk::CellRendererText.new
		column = Gtk::TreeViewColumn.new("Stock Buffer", renderer, "text" => $stock_buffer)
		@treeview.append_column(column)
		renderer = Gtk::CellRendererText.new
		column = Gtk::TreeViewColumn.new("MPOQ", renderer, "text" => $mpoq)
		@treeview.append_column(column)
		renderer = Gtk::CellRendererText.new
		column = Gtk::TreeViewColumn.new("Leadtime", renderer, "text" => $leadtime)
		@treeview.append_column(column)
		
		@tblItemStore = Gtk::ListStore.new(Integer, String, Float, Float, Integer)
		query_item_treeview()
		@treeview.model = @tblItemStore
		
	end
	
	def query_item_treeview()
		@tblItemStore.clear()
		Item.find(:all).each do |e|
			iter = @tblItemStore.append()
			@tblItemStore.set_value(iter, $id, e.id)
			@tblItemStore.set_value(iter, $description, e.description)
			@tblItemStore.set_value(iter, $stock_buffer, e.stock_buffer != nil ? e.stock_buffer : 0)
			@tblItemStore.set_value(iter, $mpoq, e.mpoq != nil ? e.mpoq : 0)
			@tblItemStore.set_value(iter, $leadtime, e.lead_time != nil ? e.lead_time : 0)
		end
	end
	
	def setup_units_combo()
		
		@cmbUnitStore = Gtk::ListStore.new(Integer, String)
		query_units_combo()
		@glade["cmbUnit"].model = @cmbUnitStore

		renderer = Gtk::CellRendererText.new()
		@glade["cmbUnit"].pack_start(renderer, true)
		@glade["cmbUnit"].set_attributes(renderer, "text" => 1)
	end
	
	def query_units_combo()
		@cmbUnitStore.clear()
		Unit.find(:all).each do |e|
			iter = @cmbUnitStore.append()
			@cmbUnitStore.set_value(iter, 0, e.id)
			@cmbUnitStore.set_value(iter, 1, e.symbol)
		end
	end
	
	def set_editing_item(item)
		@editing_item = item
		@glade["entrySearchKey"].text = @editing_item.search_key
		@glade["entryDescription"].text = @editing_item.description
		@glade["sbStockBuffer"].value = @editing_item.stock_buffer != nil ? @editing_item.stock_buffer : 0
		@glade["sbLeadtime"].value = @editing_item.lead_time != nil ? @editing_item.lead_time.to_f : 0
		@glade["sbMPOQ"].value = @editing_item.mpoq != nil ? @editing_item.mpoq : 0
		ii = nil
		if (@editing_item.logistic_type != nil)
			ii = "FIRP".index(@editing_item.logistic_type)
		end
		@glade["cmbType"].active = ii != nil ? ii : -1
		@glade["cmbUnit"].active = -1
		if (@editing_item.unit != nil)
			@cmbUnitStore.each do |model, path, iter|
				if (@editing_item.unit.id == iter[0])
					@glade["cmbUnit"].active_iter = iter
				end
			end
		end
	end
	
	def save_editing_item()
		if (@editing_item != nil)
			@editing_item.search_key = @glade["entrySearchKey"].text
			@editing_item.description = @glade["entryDescription"].text
			@editing_item.stock_buffer = @glade["sbStockBuffer"].value
			@editing_item.lead_time = @glade["sbLeadtime"].value_as_int
			@editing_item.mpoq = @glade["sbMPOQ"].value
			ii = @glade["cmbType"].active
			@editing_item.logistic_type = ii >= 0 ? "FIRP"[ii,1] : nil
			if (@glade["cmbUnit"].active_iter != nil)
				@editing_item.unit = Unit.find(@glade["cmbUnit"].active_iter[0])
			end
			@editing_item.save
		end
	end
	
	def reset_editing_item()
		set_editing_item(@editing_item)
	end
	
	# Event handlers
	def on_appwindow_delete_event(widget, arg0)
		false
	end
	
	def on_appwindow_destroy(widget)
		Gtk.main_quit
	end
	
	def on_filenewmenu_activate(widget)
		puts "New file man!"
	end
	
	def on_fileexitmenu_activate(*widget)
		appwindow.destroy
		Gtk.main_quit
	end
	
	def treeview_select_function(
			selection, model, path, path_currently_selected)
		opstat = true
		iter = model.get_iter(path)
		if (iter != nil)
			item_id = model.get_value(iter, $id)
			if (!path_currently_selected)
				# This path is going to be selected
				if (item_id != @editing_item.id)
					if (Item.exists?(item_id))
						item = Item.find(item_id)
						set_editing_item(item)
					end
				end
			else
				# This path is going to be unselected
			end
		end
		return opstat
	end
	
	def on_tbNewItem_clicked(widget)
		newItem = Item.new()
		newItem.search_key = "??"
		newItem.description = "??"
		newItem.stock_buffer = 0
		newItem.mpoq = 0
		newItem.lead_time = 1
		newItem.logistic_type = nil
		newItem.save()
		query_item_treeview()
	end
	
	def on_tbDeleteItem_clicked(widget)
	
	end
	
	def on_tbRefresh_clicked(widget)
	
	end
	
	def on_btnEditSave_activate(widget)
		save_editing_item()
		@treeview.selection.selected_each do |model, path, iter|
			iter[1] = @editing_item.description
			iter[2] = @editing_item.stock_buffer != nil ? @editing_item.stock_buffer : 0
			iter[3] = @editing_item.mpoq != nil ? @editing_item.mpoq : 0
			iter[4] = @editing_item.lead_time != nil ? @editing_item.lead_time : 0
		end
	end
	
	def on_btnEditReset_activate(widget)
		reset_editing_item()
	end
	
	#
	# Misc
	#
	def on_about(widget)
		@glade.get_widget("aboutDialog").run do |response|
		end
	end
	
	def on_about_response(widget, response)
		#puts "#{response}  CLOSE=#{Gtk::Dialog::RESPONSE_CLOSE}  DELETE=#{Gtk::Dialog::RESPONSE_DELETE_EVENT}"
		@glade.get_widget("aboutDialog").hide()
	end
end

if __FILE__ == $0
	#Gnome::Program.new(CobaGlade::NAME, CobaGlade::VERSION)
	ActiveRecord::Base.logger = Logger.new("cobaglade.log")
	ActiveRecord::Base.colorize_logging = false

	ActiveRecord::Base.establish_connection(
		:adapter => "sqlite3",
		:dbfile  => "data.dat"
	)

	o = CobaGlade.new(File.dirname($0) + "/mainwindow.glade")
	window = o.appwindow
	window.show_all
	
	Gtk.main
end
