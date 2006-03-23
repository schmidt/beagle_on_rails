class Search
	require 'lib/beagle/beagle'

	attr_accessor :string, :results

	def initialize params
		@string = params[:string] unless params[:string].nil?
	end

	def execute
		@results = Beagle.find( @string )
	end

end
