
class Msg < String
  attr_reader :comments, :reference, :flag
  attr_accessor :plurals, :id_plural, :str
  ENTRY_REGEXP = /(#[.,:]?\s*.*?\n)?msgid\s+(.+?)msg(id_plural|str)\s+(.*)/m
  def Msg::Parse(entry)
      all, com, id, sel, str = *(ENTRY_REGEXP.match(entry))
      com = com ? com.split("\n") : nil
      id.strip_q!
      if sel == 'str'
        str.strip_q!
        msg = Msg.new(str, com)
        [id, msg]
      else 
        [id, Msg::Plurals(str, com)]
      end
  end
  
  MSGSTR_PLURAL_RE = /(.+?)(msgstr\[\d+\]\s+.+?)+/m
  def Msg::Plurals(entry, com)
    all, idp, pl = *(MSGSTR_PLURAL_RE.match(entry))
    plurals = pl.strip.split(/msgstr\[\d+\]/).collect!{|mp| mp.strip_q}.compact
    Msg.new(plurals[0], com, idp.strip_q, plurals)
  end
  
  def initialize(msg, comments, idp=nil, pl=nil)
    super(msg)
    @comments = comments
    parse_comments if @comments
    @id_plural = idp
    @plurals = pl
  end
  
  def parse_comments
    @reference = if r = @comments.find{|c| c =~ /\A#:/}
                    r[2..-1].strip
                 end 
    @flag = if r = @comments.find{|c| c =~ /\A#,/}
               r[2..-1].strip
            end
  end
  
  def po_format(id, nplurals=nil)
    comments = @comments ? @comments.join("\n") << "\n" : "" 
    comments << if @id_plural
      memo = ''
      if @plurals
        pl = @plurals
      else
        pl = Array.new(nplurals, "")
      end
      pl.each_with_index{|pl, i| memo << %Q'msgstr[#{i}] "#{pl}"\n' }
      %Q(msgid "#{id}"\nmsgid_plural "#{@id_plural}"\n#{memo}\n)
    else
      %Q(msgid "#{id}"\nmsgstr "#{self}"\n\n)
    end
  end
  
   def pot_format(nplurals=nil)
    if @id_plural
      memo = ''
      (0...nplurals).each{|i| memo << %Q'msgstr[#{i}] ""\n' }
      %Q(msgid "#{self}"\nmsgid_plural "#{@id_plural}"\n#{memo}\n)
    else
      %Q(msgid "#{self}"\nmsgstr ""\n\n)
    end
  end
 
end

