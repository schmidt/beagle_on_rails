class Search
	require 'lib/beagle/beagle'

	attr_accessor :string, 
		      :results, 
		      :order,
		      :first_hit,
		      :total_time,
		      :number_of_hits

	def initialize params
		@order = 'score'
		@string = params[:string] unless params[:string].nil?
		@order = params[:order] unless params[:order].nil?
	end

	def execute
		@results = Beagle.find( @string ).sort{ |a,b| b.send( @order ) <=> a.send( @order ) }
		@first_hit = Beagle::first_hit
		@total_time = Beagle::total_time
		@number_of_hits = Beagle::number_of_hits
	end

end
