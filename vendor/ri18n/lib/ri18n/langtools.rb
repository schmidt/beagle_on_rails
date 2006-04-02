module LangTools
# target language, formated like lc_cc.chenc
# lc = two char. language code (ISO 639)
# cc = two char. country code (ISO 3166)
# chenc = charset encoding
# example: 'ja_JP.eucJP'
  attr_accessor :lang
  
  PLURAL_FAMILIES = {
  :one => %w(hu ja ko tr),
  :two_germanic => %w(da nl en de no sv et fi el he it pt es eo),
  :two_romanic => %w(fr pt_BR),
  :three_celtic => %w(ga gd),
  :three_baltic_latvian => %w(lv),
  :three_baltic_lithuanian => %w(lt),
  :three_slavic_russian => %w(hr cs ru sk uk),
  :three_slavic_polish => %w(pl),
  :four => %w(sl)}

  NPLURAL = {:one => 1,
  :two_germanic => 2,
  :two_romanic => 2,
  :three_celtic => 3,
  :three_baltic_latvian => 3,
  :three_baltic_lithuanian => 3,
  :three_slavic_russian => 3,
  :three_slavic_polish => 3,
  :four => 4  }
  
# the language code part from lang, eg 'ja' for @lang='ja_JP.eucJP'
  def language_code
    @lang[0,2]
  end
  alias_method :lc, :language_code
  
# the country code part from lang, eg 'JP' for @lang='ja_JP.eucJP'
# returns nil if there is none
  def country_code
    if m = /\w\w_(\w\w)/.match(@lang)
      m[1]
    end
  end
  alias_method :cc, :country_code
  
# the language and country code parts from lang, eg 'ja_JP' for @lang='ja_JP.eucJP'
# returns   language_code is there is no country code part
  def language_country
    if m = /(\w\w_\w\w)/.match(@lang)
      m[1]
    else
      language_code
    end
  end
  
# the charset encoding part from lang, eg 'eucJP' for @lang='ja_JP.eucJP'
# returns nil if there is none
  def lang_encoding
    if m = /\w\w(?:_\w\w)?\./.match(@lang)
      m.post_match 
    end
  end
  alias_method :le, :lang_encoding
 
  def find_family
# first seek for 'pt_BR' then for just 'pt' (for  example)
       if found = PLURAL_FAMILIES.find{|fam, list| list.include?(language_country)} || PLURAL_FAMILIES.find{|fam, list| list.include?(language_code)}
        found.first
      else
        nil
      end
  end
  
# number of plural forms
  def nplural
    NPLURAL[plural_family]
  end
  
  def plural_family
    if @lang
      find_family or :two_germanic
    else
      :two_germanic 
    end
  end
end

