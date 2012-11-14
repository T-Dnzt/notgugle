module SearchingTools
  module Searcher
    class Searcher
  	  class << self

    		def run(searched_str)
    			Rails.logger.info "Searching..."
          t1 = Time.now

          hashes = DataAccess::HashAccess.new
          db = DataAccess::DbAccess.new(hashes.database_name)    

          search_service = SearchService.new(searched_str, db, hashes)
          results = search_service.run
          results["timer"] = Time.now - t1
          results
    		end

     end
  	end
  end
end