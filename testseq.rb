require 'active_record'
require 'unit.rb'
require 'item.rb'
require 'bomnode.rb'
require 'sequencelist.rb'


if __FILE__ == $0
	ActiveRecord::Base.logger = Logger.new("testseq.log")
	ActiveRecord::Base.colorize_logging = false

	ActiveRecord::Base.establish_connection(
		:adapter => "sqlite3",
		:dbfile  => "data.dat"
	)

	bom1 = BOMNode.find(1)
	bom2 = BOMNode.find(2)
	bom3 = BOMNode.find(3)
	
	groupId = bom1.item.id
	
	seq = SequenceList.new(:context => "BOM", :seq_group => groupId, :data_id => bom1.id)
	seq.save()
	seq2 = seq.add_node(bom2.id, true)
	seq2.add_node(bom3.id, true)
	
	seq = SequenceList.find_first_node("BOM", groupId)
	while (seq)
		bom = BOMNode.find(seq.data_id)
		puts "#{seq.id} #{bom.id} #{bom.item.description} #{bom.bom_date} #{bom.start_stock} #{bom.in_qty} #{bom.out_qty}"
		seq = seq.next
	end
end
