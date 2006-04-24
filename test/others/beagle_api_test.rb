require File.dirname(__FILE__) + '/../test_helper'

require 'soap/wsdlDriver'
WSDL_URI = 'http://localhost:3000/beagle/service.wsdl'

class BeagleControllerApiTest < Test::Unit::TestCase
	def setup
	        factory = SOAP::WSDLDriverFactory.new WSDL_URI
        	@beagle = factory.create_rpc_driver
	end

	def test_execute
		search_string = "Hallo"
		search_model = @beagle.execute search_string

		assert_equal search_model.key, search_string
		assert_equal search_model.order, "score"

		assert search_model.total_time > 0.0
		assert search_model.number_of_hits > 0

		search_model.results.each { | item |
			divers = YAML::load( item.divers )
			assert_kind_of Hash, divers
		}
	end
end
