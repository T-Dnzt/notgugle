module SearchingTools
  module Searcher
    class Searcher
  	  class << self

    		def run(searched_str)
    			Rails.logger.info "Searching..."
          t1 = Time.now
          db = DataAccess::DbAccess.new('notgugle-development')
          hashes = DataAccess::HashAccess.new

          search_service = SearchService.new(searched_str, db, hashes)
          results = search_service.run
          t2 = Time.now
          Rails.logger.debug "Timer : #{t2 - t1}s"
          results
    		end

     end
  	end
  end
end