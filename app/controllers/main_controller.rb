class MainController < ApplicationController

	require 'lib/beagle/beagle'

	HITS_PER_PAGE = 10

	def index
		if not @params[:search].nil?
			@search = Search.new @params[:search]
			@search.execute
			@session[:search] = @search

		elsif not @session[:search].nil?
			@search = @session[:search]

		end

		unless @search.nil?
			@search_results = @search.results
			@result_pages = Paginator.new self, @search_results.length, HITS_PER_PAGE, @params['page']
			@search_results = 
				@search_results[(@result_pages.current.first_item - 1)..@result_pages.current.last_item - 1]
		else
			@search = Search.new Hash.new 
			render :action => 'results'
		end
	end
end
