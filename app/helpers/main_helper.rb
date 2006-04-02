module MainHelper

	def method_missing name, params
		@item = params
		render :partial => 'unknown'
	end

	def web_history item
		@item = item
		render :partial => 'web_history'
	end

	def file item
		@item = item
		render :partial => 'file'
	end

end
