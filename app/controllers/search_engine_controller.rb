class SearchEngineController < ApplicationController
	def index
		@results,@description_pages = SearchingTools::Searcher::Searcher.run(params[:search]) if params[:search]
	end

	def indexer
		SearchingTools::Indexer::Indexer.run
	end
end
