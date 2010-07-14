class Item < ActiveRecord::Base
	belongs_to :unit, :class_name => "Unit"
	end
	

