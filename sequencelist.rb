class SequenceList < ActiveRecord::Base
	set_table_name "sequence_list"
	
	belongs_to :previous, :class_name => "SequenceList"
	belongs_to :next, :class_name => "SequenceList"
	
	def add_node(dataId, insert_after)
		newNode = SequenceList.new()
		newNode.context = self.context
		newNode.seq_group = self.seq_group
		newNode.data_id = dataId
		newNode.save()
		if (insert_after)
			newNode.previous = self
			newNode.next = self.next
			if (self.next)
				self.next.previous = newNode
			end
			newNode.save()
			self.next = newNode
			save()
		else
			newNode.previous = self.previous
			newNode.next = self
			if (self.previous)
				self.previous.next = newNode
			end
			newNode.save()
			self.previous = newNode
			self.save()
		end
		return newNode
	end
	
	def delete_this_node()
		if (self.previous)
			self.previous.next = self.next
		end
		if (self.next)
			self.next.previous = self.previous
		end
		return self
	end
	
	def first?()
		return self.previous == nil
	end
	
	def last?()
		return self.next == nil
	end
	
	def SequenceList.delete_node(node_id)
		node = SequenceList.find(node_id)
		if (node)
			node.delete_this_node().destroy()
		end
	end
	
	def SequenceList.find_first_node(ctx, seqGroup)
		return SequenceList.find :first, :conditions => {:context => ctx, :seq_group => seqGroup, :previous_id => nil}
	end
	
	def SequenceList.find_last_node(ctx, seqGroup)
		return SequenceList.find :first, :conditions => {:context => ctx, :seq_group => seqGroup, :next_id => nil}
	end
	
	def SequenceList.find_first_node_with_data_id(ctx, seqGroup, dataId)
		return SequenceList.find :first, :conditions => {:context => ctx, :seq_group => seqGroup, :data_id => dataId}
	end
end
