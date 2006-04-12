class BeagleController < ApplicationController
	wsdl_service_name 'Beagle'
	web_service_scaffold :invoke

	def execute search
		search.execute
		return search
	end

	def execute_with_string query
		param = {:key => query.dup}
		search = Search.new param
		search.execute
		return search
	end
end
