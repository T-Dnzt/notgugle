class SearchEngineController < ApplicationController
	def index
		@results,@desc_pages = SearchingTools::Searcher::Searcher.run(params[:search]) if params[:search]
	end

	def indexer
		SearchingTools::Indexer::Indexer.run
	end
end
