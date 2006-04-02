#!/usr/bin/env ruby

require 'test_helper'
require 'ri18n/catalog'

class PoPackagingTest < Test::Unit::TestCase
  def test_available
    wd = Dir.getwd
    assert_equal(%w{de fr}, I18N.available_languages)

    # check that workdir is not changed
    assert_equal(wd, Dir.getwd)
  end
end

  def assert_catalog_content_is(expected, catalog)
    cont = catalog.dup
    cont.delete("")
    assert_equal(expected, cont)
  end

class PluralTest < Test::Unit::TestCase

	def test_plural_romanic
		I18N.lang='fr'
		
		assert_equal '0 fichier', n_('%i file', '%i files', 0)
		assert_equal '1 fichier', n_('%i file', '%i files', 1)
		assert_equal '2 fichiers', n_('%i file', '%i files', 2)
	end

	def test_plural_germanic
		I18N.lang='de'
		
		assert_equal '0 dateien', n_('%i file', '%i files', 0)
		assert_equal '1 datei', n_('%i file', '%i files', 1)
		assert_equal '2 dateien', n_('%i file', '%i files', 2)
	end
	
	
end

class TranslationIOTest < Test::Unit::TestCase

  def setup
    po = <<END_PO
msgid "hello"
msgstr "salut"

msgid "two"
msgstr "deux"

msgid "blue"
msgstr "bleu"

msgid "untranslated"
msgstr ""

END_PO

    I18N.in_po_dir do
      File.open('iotest', File::CREAT|File::WRONLY|File::TRUNC){|f|
                f << po
      }
    end

  end

  def teardown
    I18N.in_po_dir do
      File.delete('iotest') if test(?f, 'iotest')
    end
  end

  def test_load
    assert_catalog_content_is({'hello' => 'salut', 'two' => 'deux', 'blue' => 'bleu',
                  'untranslated' => "" }, I18N.read_po('iotest'))
  end

  
end

class InterpTest < Test::Unit::TestCase
  def setup
    interp_setup
    I18N.lang = nil
  end
  def teardown
    interp_teardown
  end
  def test_interp_simple
    I18N.lang = 'iotest_interp'
    @interpolation = 'toto'
    assert_equal('test toto', _i('#{@interpolation} test') )

    @interpolation = 'tutu'
    assert_equal('test tutu', _i('#{@interpolation} test') )

  end
  def test_interp
    I18N.lang = 'iotest_interp'
    assert_catalog_content_is({'#{@interpolation} test' => 'test #{@interpolation}',
                 'blue' => 'bleu'}, I18N.table)
    assert_equal('bleu', _('blue'))
    assert_equal('red', _('red'))

    @interpolation = _('blue')
    assert_equal('test bleu', _i('#{@interpolation} test') )

    @interpolation = _('red')
    assert_equal('test red', _i('#{@interpolation} test') )

  end
end

class TranslationTest < Test::Unit::TestCase
  # reset to default
  def setup
    I18N.lang='xx'
    I18N.table = Catalog.new('xx')
    I18N.table.replace({'blue' => 'bleu', 'summer' => 'été', 'untranslated' => ""})
    I18N.write_po('xx')

    I18N.lang = nil
  end

  def teardown
    I18N.in_po_dir do
      File.delete(I18N.filename('xx')) if test(?f, I18N.filename('xx'))
      File.delete(I18N.filename('yy')) if test(?f, I18N.filename('yy'))
    end
  end


  def test_default_is_english
    assert_equal('Test String', _('Test String'))
  end

  def test_load_and_save
    assert_catalog_content_is({}, I18N.table)
    assert_equal('blue', _('blue'))
    assert_equal('untranslated', _('untranslated'))
    assert_equal('summer', _('summer'))

    I18N.lang = "xx"
    assert_catalog_content_is({'blue' => 'bleu', 'summer' => 'été', 'untranslated' => ""},
                                I18N.table)
    assert_equal('bleu', _('blue'))
    assert_equal('untranslated', _('untranslated'))
    assert_equal('été', _('summer'))

  end
  
  def test_update
    new_messages = ['red', 'blue'].collect{|m| Msg.new(m, nil)}
    new_messages << Msg.new('%i file', nil, '%i files')
    I18N.update('xx', new_messages)
    assert_catalog_content_is({'blue' => 'bleu', 'red' => "",
                  'summer' => 'été', 'untranslated' => "",
                  '%i file' => ""}, I18N.table)
    assert_equal('%i files', I18N.table['%i file'].id_plural)
    assert_equal(["", ""], I18N.table['%i file'].plurals)
  end

  def test_create_catalogs
    new_msg = ['blue', 'red', 'summer', 'untranslated'].collect{|m| Msg.new(m, nil)}
    
    I18N.create_catalogs(new_msg, [])
    assert_equal ['de', 'fr', 'xx'], I18N.available_languages
    
    I18N.create_catalogs(new_msg, ['xx', 'yy'])
    
    assert_equal ['de', 'fr', 'xx', 'yy'], I18N.available_languages
    I18N.lang = "yy"
    assert_catalog_content_is({'blue' => "", 'red' => "",
                  'summer' => "", 'untranslated' => ""}, I18N.table)
                  
    I18N.lang = "xx"
    assert_catalog_content_is({'blue' => 'bleu', 'summer' => 'été', 'untranslated' => ""},
                                I18N.table)
    
  end
  
  def test_simple
    I18N.lang = "fr"
    assert_equal('Test de cuisson', _('Cooking test'))

    I18N.lang = "de"
    assert_equal('Kochtest', _('Cooking test'))
  end

  def test_utf8_chars
    I18N.lang = "fr"
    assert_equal('Chaîne de Test', _('Test String'))
    assert_equal('Été', _('Summer'))
    assert_equal('été', _('summer'))

    I18N.lang = "de"
    assert_equal('Straße', _('Road'))
  end
end