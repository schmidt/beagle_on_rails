
require 'test/unit'
require 'ri18n/po'

class PoHelperTest < Test::Unit::TestCase
  include PoHelper
  def test_parse_content_type
    assert_equal( 'ISO-8859-2', 
              parse_content_type("text/plain; charset=ISO-8859-2"))
  end
end


class PoSourceTest < Test::Unit::TestCase
  
  P1 = <<PO_END
msgid "one"
msgstr "un"
PO_END
  E1 = {'one' => 'un'}
  P2 = P1 + <<PO_END

msgid "two"
msgstr "deux"
PO_END
  E2 = {'one' => 'un', 'two' => 'deux'}
  
  P3 = <<PO_END + P1
#  translator-comments
#. automatic-comments
#: reference...
#, flag...
PO_END
  E3 = E1
  
  HC = <<-'PO_END'
# SOME DESCRIPTIVE TITLE.
# Copyright (C) YEAR Free Software Foundation, Inc.
# This file is distributed under the same license as the PACKAGE package.
# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.
#
#, fuzzy
  PO_END
  
  PH = HC + <<-'PO_END'
msgid ""
msgstr ""
"Project-Id-Version: PACKAGE VERSION\n"
"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\n"
"POT-Creation-Date: 2002-12-10 22:11+0100\n"
"Last-Translator: FULL NAME <EMAIL@ADDRESS>\n"
"Language-Team: LANGUAGE <LL@li.org>\n"
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=CHARSET\n"
"Content-Transfer-Encoding: ENCODING\n"

  PO_END
  
  EH = {'Project-Id-Version' => 'PACKAGE VERSION',
        'PO-Revision-Date' => 'YEAR-MO-DA HO:MI+ZONE',
        'POT-Creation-Date' => '2002-12-10 22:11+0100',
        'Last-Translator' => 'FULL NAME <EMAIL@ADDRESS>',
        'Language-Team' => 'LANGUAGE <LL@li.org>',
        'MIME-Version' => '1.0',
        'Content-Type' => 'text/plain; charset=CHARSET',
        'Content-Transfer-Encoding' => 'ENCODING',
        :comments =>  HC
        }  

  def test_parse_one
    assert_equal(E1, PoSource.new(P1, 'fr').parse )
    assert_equal(E1, PoSource.new(P1 + "\n", 'fr').parse )
    assert_equal(E1, PoSource.new(P1 + "\n\n", 'fr').parse )
  end
  
  def test_parse_two
    assert_equal(E2, PoSource.new(P2, 'fr').parse )
    assert_equal(E2, PoSource.new(P2+ "\n", 'fr').parse )
    assert_equal(E2, PoSource.new(P2+ "\n\n", 'fr').parse )
  end
  
# does not work anymore because header is added automatically
#   def test_formating
#     assert_equal(P2.strip, PoSource.new(P2).parse.po_format(2).strip)
#   end
  
  def test_parse_with_comment
    p3 = PoSource.new(P3, 'fr').parse
    assert_equal(E3, p3)
    
    assert_respond_to(p3['one'], :comments)
    assert_equal(['#  translator-comments', 
                  '#. automatic-comments',
                  '#: reference...',
                  '#, flag...'], p3['one'].comments)
    
  end
  
  def test_comments_are_kept
    assert_match(/#{P3.strip}\z/m, PoSource.new(P3, 'fr').parse.po_format.strip )
  end
  
  def test_parse_header
    ph = PoSource.new(PH, 'fr').parse_header
    EH.each{|key, val|
      assert_equal(val, ph[key])
    }
  end
  
  def test_format_header
    htable = PoSource.new(PH, 'fr')
    htable.parse_header
    assert_equal(PH, htable.table.po_header('utf-8'))
  end
end
