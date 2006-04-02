
require 'test/unit'
require 'ri18n/msg'

class MsgTest < Test::Unit::TestCase
  
  E1 = <<ENTRY_END
#  translator-comments
#. automatic-comments
#: reference...
#, flag...
msgid "untranslated-string"
msgstr "translated-string"
ENTRY_END

  E2 = <<ENTRY_END
#  translator-comments
#. automatic-comments
#: reference...
#, flag...
msgid "untranslated-string-singular"
msgid_plural "untranslated-string-plural"
msgstr[0] "translated-string-case-0"
msgstr[1] "translated-string-case-1"
msgstr[2] "translated-string-case-2"
ENTRY_END

  def test_parse
    id, msg = Msg::Parse(E1)
    assert_equal 'untranslated-string', id
    assert_equal 'translated-string', msg
    assert_equal nil, msg.id_plural
    assert_equal nil, msg.plurals
  end
  
  def test_parse_with_plural
    id, msg = Msg::Parse(E2)
    assert_equal 'untranslated-string-singular', id
    assert_equal 'untranslated-string-plural', msg.id_plural
    assert_equal(%w{translated-string-case-0 translated-string-case-1 translated-string-case-2},
                 msg.plurals)
    assert_equal('translated-string-case-0', msg)
  end
 
  def test_parse_comments
    m = Msg.new('message', ['#  translator-comments', 
                  '#. automatic-comments',
                  '#: reference...',
                  '#, flag...'])
    assert_equal 'reference...', m.reference
    assert_equal 'flag...', m.flag
  end
  
  def test_po_format_singular
    str = Msg.new('translated message', nil)
    expect = <<END_PO
msgid "message"
msgstr "translated message"

END_PO
    assert_equal expect, str.po_format('message')
  end

  def test_po_format_plural
    str = Msg.new("", nil, '%i files', ['%i fichier', '%i fichiers'])
    expect = <<END_PO
msgid "%i file"
msgid_plural "%i files"
msgstr[0] "%i fichier"
msgstr[1] "%i fichiers"

END_PO
    assert_equal expect, str.po_format('%i file')
  end

  def test_pot_format_singular
    id = Msg.new('message id', nil)
    expect = <<END_PO
msgid "message id"
msgstr ""

END_PO
    assert_equal expect, id.pot_format
  end

  def test_pot_format_plural
    str = Msg.new("%i file", nil, '%i files')
    expect = <<END_PO
msgid "%i file"
msgid_plural "%i files"
msgstr[0] ""
msgstr[1] ""

END_PO
    assert_equal expect, str.pot_format(2)
  end
end
