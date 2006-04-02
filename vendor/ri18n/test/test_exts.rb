require 'test/unit'
require 'ri18n/standard_exts'

class StringUnescapequoteTest < Test::Unit::TestCase
  def test_simple
    string = 'heyyyy \'blah\' yo'
    assert_equal "heyyyy 'blah' yo", string.unescape_quote
    
    string = "heyyyy 'blah' yo"
    assert_equal string, string.unescape_quote
  end
end

class StringInterpolateTest < Test::Unit::TestCase
  
  def test_unchanged
    string = 'blah'
    assert_equal string, string.interpolate(self)
  end
  
  def test_simple
    @color = 'red'
    string = 'the horse is #{@color}'
    assert_equal 'the horse is red', string.interpolate(self)
    
    @color = 'blue'
    assert_equal 'the horse is blue', string.interpolate(self)
  end
  
  def test_quotes
    @color = 'red'
    string = %q(the horse is '#{@color}')
    assert_equal %q(the horse is 'red'), string.interpolate(self)
  end
  
  def test_dquotes
    @color = 'red'
    string = %q(the horse is "#{@color}")
    assert_equal %q(the horse is "red"), string.interpolate(self)
  end
end

class StringStrip_qTest < Test::Unit::TestCase

  def test_strip_q
    assert_equal 'blah bla bla  ', '   "blah bla bla  " '.strip_q
  end
  
  def test_strip_q!
    s = '   "blah bla bla  " '
    s.strip_q!
    assert_equal 'blah bla bla  ', s
  end

# TODO: make this work (even if it is not needed in the code for now)
  def _test_strip_q_incomplete
    assert_equal 'blah bla bla', '   "blah bla bla '.strip_q
  end

end