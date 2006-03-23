class MainController < ApplicationController

	require 'lib/beagle/beagle'

	def index
		unless @params[:search].nil?
			@search = Search.new @params[:search]
			@search.execute
		end
	end
end
