class SearchEngineController < ApplicationController
	def index
	end

	def indexer
		SearchingTools::Indexer::Indexer.run
		#SearchingTools::Searcher::Searcher.run("ruby")
	end
end
