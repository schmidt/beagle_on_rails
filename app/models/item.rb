class Item < ActionWebService::Struct
	attr_accessor :uri, :pa_uri, :snip, :type, :mime_type, :source, :score, :time, :divers

	member :uri, 	:string
	member :pa_uri, :string
	member :snip,	:string
	member :type,	:string
	member :mime_type, :string
	member :source,	:string
	member :time,	:datetime

end
