require 'active_record'
require 'unit.rb'
require 'item.rb'
require 'bomnode.rb'

class ConsoleAdm
	def initialize
		
	end
	
	def start
		puts "Welcome!"
		puts
		puts "======== BOM Console ========="
		puts
		while (true)
			print ">> "
			cmd = gets
			if (cmd == nil)
				break
			end
			if (cmd.chomp().eql?("exit"))
				break
			end
			if (cmd.chomp().eql?("add item"))
				add_item()
				next
			end
			if (cmd.chomp().eql?("list items"))
				list_item()
				next
			end
			if (cmd.chomp().eql?("delete item"))
				delete_item()
				next
			end
			puts "E: unknown"
		end
	end
	
	def add_item
		
		print "Search key: "
		search_key = gets.chomp()
		return if search_key.length() <= 0
		
		print "Description: "
		desc = gets.chomp()
		print "Type: "
		logistic_type = gets.chomp()
		print "Stock Buffer: "
		stock_buffer = gets.chomp().to_f
		print "Leadtime: "
		lead_time = gets.chomp().to_f
		print "MPOQ: "
		mpoq = gets.chomp().to_f
		
		unit = get_unit()
		
		item = Item.new
		item.search_key = search_key
		item.description = desc
		item.logistic_type = logistic_type
		item.stock_buffer = stock_buffer
		item.lead_time = lead_time
		item.mpoq = mpoq
		item.unit = unit
		item.save
	end
	
	def list_item
		items = Item.find(:all)
		items.each do |e|
			puts "[#{e.id}]\t#{e.search_key}\t#{e.description}"
		end
	end
	
	def delete_item
		print 'id: '
		sid = gets
		if (sid == nil)
			return
		end
		id = sid.to_i
		if (id > 0)
			
			if (Item.exists?(id))
				Item.destroy(id)
			else
			puts 'E: not found'
			end
		end
	end
	
	def get_unit
		retval = nil
		units = Unit.find(:all)
		units.each do |e|
			puts "[#{e.id}] #{e.symbol}"
		end
		print "Select unit ID: "
		id = gets.chomp().to_i
		if id > 0
			retval = Unit.find(id)
		end
		return retval
	end
end

if __FILE__ == $0

	ActiveRecord::Base.logger = Logger.new("bomconsole.log")
	ActiveRecord::Base.colorize_logging = false
	ActiveRecord::Base.establish_connection(
		:adapter => "sqlite3",
		:dbfile  => "data.dat"
	)
	
	console = ConsoleAdm.new()
	console.start()
end
