class BeagleApi < ActionWebService::API::Base

	api_method :execute,
		   :expects => [{:query => :string}],
		   :returns => [Search]
	
	api_method :execute_with_order,
        	   :expects => [{:query => :string}, {:order => :string}],
		   :returns => [Search]
end
