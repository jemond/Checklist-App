class PagesController < ApplicationController
	layout 'public'
	caches_page :show, :index
	
	# home page
	def index
	end
	
	def about
	end
	
	def samples
	end
end