$: << File.dirname(__FILE__)

require 'singleton'
require 'fileutils'

require 'ri18n/standard_exts'
require 'ri18n/po'
require 'ri18n/langtools'

class I18nService
  include Singleton
  include LangTools
  
  attr_accessor :table
  attr_accessor :po_dir
  attr_reader :application_encoding
  alias_method :kcode, :application_encoding
    
  FILE_SUFFIX = '.po'
  FILE_PATTERN = "*#{FILE_SUFFIX}"
  
  def lang=(l)
    unless ( @lang == l ) 
      @lang = l 
			load 'ri18n/plural_forms.rb'
      load 'ri18n/translators.rb' 
    end
  end

  def application_encoding
    case $KCODE[0,1].downcase
    when 'u'
      'UTF-8'
    when 'e'
      'EUC-JP'
    when 's'
      'Shift-JIS'
    else
      'ASCII'
    end
  end
  
# execute code bloc in the PO dir
  def in_po_dir #:nodoc:
    wd = Dir.getwd
    ret = nil
    begin
      Dir.chdir(@po_dir)
      ret = yield
    ensure
      Dir.chdir(wd)
    end
    ret
  end
  
  # access the po files
  def each_file #:nodoc:
    in_po_dir do
      Dir[FILE_PATTERN].each{|fn| yield fn}
    end
  end
  
# list of languages that have a catalog in the current +po_dir+
  def available_languages
    ret = in_po_dir do
      Dir[FILE_PATTERN]
    end
    ret.collect{|path| File.basename(path, FILE_SUFFIX)}.sort
  end  
  
# for all availables catalogues, add messages that do not already exist in them
  def update_catalogs(new_msgs)
    available_languages.each{|la| self.update(la, new_msgs)    }
  end
  
# for every lang. that does not already have a catalog, create one with 
# the +new_msg+ content
  def create_catalogs(new_msg, new_langs)
# dont overwrite existing catalogs
    new_langs =  new_langs.dup - available_languages
    new_langs.each{|l|
      @lang = l
      @table = Catalog.new(@lang)
      @table.update(new_msg)
      write_po(l)
    }
  end
  
  
# add messages in an existing 'lang' catalog that do not already exist in it
  def update(lang, new_msg)
    self.lang = lang
    @table.update(new_msg)
    write_po(lang)
  end
  
  def filename(lang) #:nodoc:
    lang + FILE_SUFFIX
  end
  
# Read and parse a PO file, convert encoding to application_encoding
  def read_po(fn)
    in_po_dir do
      PoSource.new(File.read(fn), @lang).parse(application_encoding)
    end
  end
  
# tries to load the PO file for the actual language (@lang)
  def try_load #:nodoc:
    loaded = true	
    if @lang and @lang.kind_of?(String) then
      begin
        @table = read_po(filename(@lang))
      rescue Errno::ENOENT
        loaded = false
      end
    else
      loaded = false
    end
    loaded
  end
  
# write the actual catalog in a PO file
  def write_po(lang)
    fname = filename(lang)
    in_po_dir do
      FileUtils.cp(fname, "#{fname}.bak") if test(?f, fname)
      File.open(fname, File::CREAT|File::WRONLY|File::TRUNC){|f|
        f << @table.po_format(application_encoding)
      }
    end
  end
  
# write a PO template file (POT)
  def write_pot(t)#:nodoc:
    fname = 'en.pot'
    in_po_dir do
      FileUtils.cp(fname, "#{fname}.bak") if test(?f, fname)
      File.open(fname, File::CREAT|File::WRONLY|File::TRUNC){|f|
        f << t.pot_format(nplural, application_encoding)
      }
    end
  end

end


# this is needed so that translators and plural forms get loaded
# even if the app that uses i18nservice does not set a language
load 'ri18n/plural_forms.rb'
load 'ri18n/translators.rb' 

