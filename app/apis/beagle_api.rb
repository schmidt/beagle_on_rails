class BeagleApi < ActionWebService::API::Base
	api_method :execute,
        	   :expects => [{:search_options => Search}],
		   :returns => [Search]

	api_method :execute_with_string,
		   :expects => [{:query => :string}],
		   :returns => [Search]
end
