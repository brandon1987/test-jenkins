class GridLookupData
	attr_accessor :draw
	attr_accessor :recordsTotal
	attr_accessor :recordsFiltered
	attr_accessor :data
	attr_accessor :error
	attr_accessor :totals	
	
	def initialize()
		@draw
		@recordsTotal
		@recordsFiltered
		@data
		@error
		@totals
	end
end