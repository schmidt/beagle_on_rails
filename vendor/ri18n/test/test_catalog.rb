require 'test/unit'
require 'ri18n/catalog'

def assert_formated_ends_with(expect, formated)
  assert_match(/#{Regexp.escape(expect)}\z/, formated)
end

def assert_catalog_content_is(expected, catalog)
  cont = catalog.dup
  cont.delete("")
  assert_equal(expected, cont)
end

class CatalogTest < Test::Unit::TestCase
  def test_po_format
    c = Catalog.new('fr')
    c.replace({'blue' => 'bleu', 'summer' => 'été', 'untranslated' => ""})
    expect = <<EOS
msgid "blue"
msgstr "bleu"

msgid "summer"
msgstr "été"

msgid "untranslated"
msgstr ""

EOS
    assert_formated_ends_with(expect, c.po_format)
  end

  def test_po_format_header
    c = Catalog.new('fr')
    header = {:comments => "# comment1\n# comment2", 
              :ordered_entries => ['Content-Type', 'Content-Transfer-Encoding'],
              'Content-Type' => 'text/plain; charset=utf-8',
              'Content-Transfer-Encoding' => '8bit',
              }
    c.replace({"" => header, 'blue' => 'bleu', 'untranslated' => ""})
    expect = <<'EOS'
# comment1
# comment2
msgid ""
msgstr ""
"Content-Type: text/plain; charset=utf-8\n"
"Content-Transfer-Encoding: 8bit\n"

msgid "blue"
msgstr "bleu"

msgid "untranslated"
msgstr ""

EOS
    assert_formated_ends_with(expect, c.po_format)
  end
  def test_po_format_comments
    c = Catalog.new('fr')
    mid = Msg.new('été', ['# comment1', '# comment2'])
    c.replace({'blue' => 'bleu', 'summer' => mid, 'untranslated' => ""})
    expect = <<'EOS'
msgid "blue"
msgstr "bleu"

# comment1
# comment2
msgid "summer"
msgstr "été"

msgid "untranslated"
msgstr ""

EOS
    assert_formated_ends_with(expect, c.po_format)
  end

  def test_po_format_plural
    c = Catalog.new('fr')
    midplural = Msg.new('toto', nil, '%i files', ['%i fichier', '%i fichiers'])
    c.replace({'blue' => 'bleu', '%i file' => midplural, 'untranslated' => ""})
    expect = <<'EOS'
msgid "%i file"
msgid_plural "%i files"
msgstr[0] "%i fichier"
msgstr[1] "%i fichiers"

msgid "blue"
msgstr "bleu"

msgid "untranslated"
msgstr ""

EOS
    assert_formated_ends_with(expect, c.po_format)
  end
  
  def test_update
    new_messages = ['red', 'blue'].collect{|m| Msg.new(m, nil)}
    new_messages << Msg.new('%i file', nil, '%i files')
    c = Catalog.new('fr')
    c.replace({'blue' => 'bleu', 'summer' => 'été', 'untranslated' => ""})
    c.update(new_messages)
    assert_catalog_content_is({'blue' => 'bleu', 'red' => "",
                  'summer' => 'été', 'untranslated' => "",
                  '%i file' => ""}, c)
    assert_equal('%i files', c['%i file'].id_plural)
    assert_equal(["", ""], c['%i file'].plurals)
  end

end

