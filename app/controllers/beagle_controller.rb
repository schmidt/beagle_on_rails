class BeagleController < ApplicationController
	wsdl_service_name 'Beagle'
	web_service_scaffold :invoke

	def execute query
		param = { :key => query.dup }
		search = Search.new param

		search.execute

		return copy( search )
	end

	def execute_with_order query, order
		param = {:key => query.dup, :order => order.dup}
		search = Search.new param

		search.execute

		return copy( search )
	end

private 
	def copy search
	# Umkopieren aller Ergebnisse - keine Ahnung, warum das nötig ist
		Search.new(
			:key => search.key, 
			:order => search.order,
			:results => search.results.collect { |item|
				Item.new( 
					:uri => item.uri, 
					:pa_uri => item.uri,
					:snip => item.snip,
					:type => item.type,
					:mime_type => item.mime_type,
					:source => item.source,
					:time => item.time )
				},
			:first_hit => search.first_hit,
			:total_time => search.total_time,
			:number_of_hits => search.number_of_hits  )
	end

end
