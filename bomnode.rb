class BOMNode < ActiveRecord::Base
	F_CALCULATE = 1
	
	set_table_name "bom_nodes"
	belongs_to :parent, :class_name => "BOMNode"
	has_many :children, :class_name => "BOMNode", :foreign_key => :parent_id
	belongs_to :item, :class_name => "Item"
	
	def calculate(startingStock)
		if (flags & F_CALCULATE)
			if (startingStock < self.item.stock_buffer)
				batchCount = ((self.item.stock_buffer - startingStock).to_f / self.item.mpoq.to_f).ceil
				self.in_qty = batchCount * self.item.mpoq
				self.start_stock = startingStock + self.in_qty - self.out_qty
			end
		end
	end
	
	def explode()
		
	end
end


