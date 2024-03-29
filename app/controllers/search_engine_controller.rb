class SearchEngineController < ApplicationController
	def index
		@results = SearchingTools::Searcher::Searcher.run(params[:search]) if params[:search]
	end

	def indexer
		@timer = SearchingTools::Indexer::Indexer.run
	end
end
