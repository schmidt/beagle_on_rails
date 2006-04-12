class Search < ActionWebService::Struct
	require 'lib/beagle/beagle'

	attr_accessor :key, 
		      :results, 
		      :order,
		      :first_hit,
		      :total_time,
		      :number_of_hits

	member :key, :string
	member :results, [Item]
	member :order, :string
	member :first_hit, :float
	member :total_time, :float
	member :number_of_hits, :int

	def initialize params
		@order = 'score'
		@key = params[:key] unless params[:key].nil?
		@order = params[:order] unless params[:order].nil?
	end

	def execute
		@results = Beagle.find( @key ).sort{ |a,b| b.send( @order ) <=> a.send( @order ) }
		@first_hit = Beagle::first_hit
		@total_time = Beagle::total_time
		@number_of_hits = Beagle::number_of_hits
	end

end
