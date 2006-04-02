
require 'ri18n/standard_exts'
require 'ri18n/msg'
require 'ri18n/newmsglist'
require 'rubygems'
require 'rake'
require 'rake/tasklib'

class GettextScanner < String
  SINGLE = "'(.+?)'"
  DOUBLE = '"(.+?)"'
  MSG_PATTERN_SINGLE = /\W_i?\(#{SINGLE}\)/mu
	MSG_PATTERN_DOUBLE = /\W_i?\(#{DOUBLE}\)/mu
  MSG_PATTERN_PLURAL = /\Wn_\(#{SINGLE},\s*#{SINGLE},\s*.+?\)/mu
	def GettextScanner::Gettext(source)
		GettextScanner.new(source).gettext
	end
	
  def gettext
		ret = (scan(MSG_PATTERN_SINGLE) + scan(MSG_PATTERN_DOUBLE)).flatten.uniq.sort
	  plur = scan(MSG_PATTERN_PLURAL).uniq
    ret += plur.sort
    ret.collect{|m|
      case m
      when String # singular msg
        Msg.new(m.unescape_quote, nil)
      when Array # plural msg
        Msg.new(m[0].unescape_quote, nil, m[1].unescape_quote)
      end
    }
  end
end

# TODO: detect app KCODE (read config file ?) and write PO and POT files accordingly 
module Rake
  
  class GettextTask < TaskLib
  
# Name of gettext task. (default is :gettext)
    attr_accessor :name

# True if verbose test output desired. (default is false)
    attr_accessor :verbose

# Glob pattern to match source files. (default is '**/*.rb')
    attr_accessor :pattern

# an array of file names (a FileList is acceptable) that will be scanned for i18n strings
    attr_accessor :source_files
# an array of languages (locales) for wich you want a new catalog 
   attr_accessor :new_langs
# Create a gettext task.
    def initialize(name=:gettext)
      @name = name
      @pattern = nil
      @source_files = nil
      @new_langs = nil
      @verbose = false
      yield self if block_given?
      @pattern = '**/*.rb' if @pattern.nil? && @source_files.nil?
      define
    end

# Create the tasks defined by this task lib.
    def define
      desc "Ri18n gettext task" + (@name==:gettext ? "" : " for #{@name}")
      task @name do
        msg_list = get_new_messages
        I18nService.instance.update_catalogs(msg_list)
        I18nService.instance.create_catalogs(msg_list, new_langs )
      end
      self
    end
    
    def file_list # :nodoc:
      result = []
      result += @source_files.to_a if @source_files
      result += FileList[ @pattern ].to_a if @pattern
      FileList[result]
    end
    
    def get_new_messages # :nodoc:
      list = []
      file_list.each{|fn|
        next unless test(?f, fn)
        File.open(fn) do |f|
          new_strings = GettextScanner::Gettext(f.read)
          if @verbose
            unless new_strings.empty?
              puts "I18n messages in #{fn}:"
              new_strings.each{|s| puts " * #{s}"}
            end
          end
          list += new_strings
        end
      }
      NewMsgList.new(list.uniq)
    end
     
  end # class GettextTask
end # module Rake
