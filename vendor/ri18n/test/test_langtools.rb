require 'test/unit'
require 'ri18n/langtools'

class PluralTest < Test::Unit::TestCase
  include LangTools
  def test_plural_families
    @lang='en'
    assert_equal :two_germanic, plural_family

    @lang='ga'
    assert_equal :three_celtic, plural_family
    
    @lang='de'
    assert_equal :two_germanic, plural_family
    
    @lang='lv'  
    assert_equal :three_baltic_latvian, plural_family
    
    @lang='fr'  
    assert_equal :two_romanic, plural_family
    
    @lang='lt'  
    assert_equal :three_baltic_lithuanian, plural_family
    
    @lang='fr_FR.ISO-8859-2'  
    assert_equal :two_romanic, plural_family
    
    @lang='pt'  
    assert_equal :two_germanic, plural_family
    
    @lang='pt.utf-8'  
    assert_equal :two_germanic, plural_family
   
    @lang='pt_BR'
    assert_equal :two_romanic, plural_family
    
    @lang='pt_BR.utf-8'
    assert_equal :two_romanic, plural_family
  end
end

class LangToolsTest < Test::Unit::TestCase
  include LangTools
  def setup
    @lang = 'ja_JP.eucJP'
  end
  def teardown
    @lang = nil
  end
  
  def test_lang_code
    assert_equal('ja', language_code)
    assert_equal('ja', lc)
  end
  
  def test_country_code
    assert_equal('JP', country_code)
    assert_equal('JP', cc)
    
    @lang = 'ja'
    assert_equal(nil, country_code)
  end
  
  def test_language_country
    assert_equal('ja_JP', language_country)
    
    @lang = 'ja'
    assert_equal('ja', language_country)
  end
    
  def test_encoding
    assert_equal('eucJP', lang_encoding)
    assert_equal('eucJP', le)
    @lang = 'fr_FR.ISO-8859-2'
    assert_equal('ISO-8859-2', lang_encoding)
    @lang = 'fr.ISO-8859-2'
    assert_equal('ISO-8859-2', lang_encoding)
    @lang = 'fr'
    assert_equal(nil, lang_encoding)
  end
end
