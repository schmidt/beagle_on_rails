require File.dirname(__FILE__) + '/../test_helper'
require 'beagle_controller'

class BeagleController; def rescue_action(e) raise e end; end

class BeagleControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = BeagleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_execute
    result = invoke :execute, "Hallo"
    assert_kind_of Search, result
  end
end
