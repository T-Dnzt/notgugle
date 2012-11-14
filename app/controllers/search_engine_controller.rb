class SearchEngineController < ApplicationController
	def index
		@results,@desc_pages = SearchingTools::Searcher::Searcher.run(params[:search]) if params[:search]
	end

	def indexer
		@indexing_state = (SearchingTools::Indexer::Indexer.run) ? "Ok" : "Non"
	end
end
