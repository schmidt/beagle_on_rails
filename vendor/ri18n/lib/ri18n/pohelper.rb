
module PoHelper

# parse content_type and return charset encoding
#  "text/plain; charset=ISO-8859-2" => 'ISO-8859-2'
  def parse_content_type(content_type)
    %r{(?:\w|\d|[-/])+;\s+charset=((?:\w|\d|-)+)\z}.match(content_type)[1]
  end
  
# charset encoding of the PO file. defaults to utf-8 if it is not defined in the PO header   
  def encoding
  # return if there is was no PO header to get an encoding from
    return 'utf-8' unless header
    return 'utf-8' unless ct = header['Content-Type']
    parse_content_type(ct)
  end
end

