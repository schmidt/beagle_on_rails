module MainHelper

	def method_missing name, params
		@item = params
		render :partial => 'unknown'
	end

	def convert_markup old
		new = old.gsub /(<font color="red">)|(<\/font>)/, ""
		return new.gsub( /<(\/?)b>/, '<\1strong>' )
	end

	def web_history item
		@item = item
		
		@title = (@item.divers.nil? || @item.divers[:dc].nil? || @item.divers[:dc][:title].nil?) ? @item.uri : @item.divers[:dc][:title]
		
		@counter = @counter || 0
		@counter += 1
		
		render :partial => 'web_history'
	end

	def file item
		@item = item

		case true
			when item.mime_type.starts_with?( 'inode/' )
				@clas = 'directory'
			when item.mime_type.starts_with?( 'image/' )
				@clas = 'picture'
			else
				@clas = 'file'
		end
		
		@counter = @counter || 0
		@counter += 1

		render :partial => 'file'
	end

end
