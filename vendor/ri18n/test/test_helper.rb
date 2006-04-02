require 'test/unit'

require 'i18nservice'
I18N = I18nService.instance
I18N.po_dir = File.dirname(__FILE__) + '/po'

def interp_setup
    poi = <<'END_POI'

msgid "#{@interpolation} test"
msgstr "test #{@interpolation}"

msgid "blue"
msgstr "bleu"

END_POI

    I18N.in_po_dir do
      File.open('iotest_interp.po',
                 File::CREAT|File::WRONLY|File::TRUNC){|f|  f << poi   }
    end
end

def interp_teardown
  I18N.in_po_dir do
    File.delete('iotest_interp.po') if test(?f, 'iotest_interp.po')
  end
end

def plural_setup
    poi = <<'END_POI'
msgid ""
msgstr "Plural-Forms: nplurals=2; plural=n == 1 ? 0 : 1;\n"

msgid "file"
msgid_plural "files"
msgstr[0] "fichier"
msgstr[1] "fichiers"
END_POI

    I18N.in_po_dir do
      File.open('plural.po',
                 File::CREAT|File::WRONLY|File::TRUNC){|f|  f << poi   }
    end
end

def plural_teardown
  I18N.in_po_dir do
    File.delete('plural.po') if test(?f, 'plural.po')
  end
end
