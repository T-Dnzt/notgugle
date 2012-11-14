module SearchingTools
  module Indexer
	  class Indexer
	  	class << self
	  		def run
	  			Rails.logger.info "Indexing..."
          t1 = Time.now
          db = DataAccess::DbAccess.new('notgugle-development')
          hashes = DataAccess::HashAccess.new
          
          Dir.glob("#{path_to_files}/*.html") do |file|
            parser = Parser.new(file, db, hashes)
            parser.run
            parser.display_variables
          end

          t2 = Time.now
          Rails.logger.debug "Timer : #{t2 - t1}s"
	  		end

	  		def path_to_files
          Rails.root.join('public/html')
	  		end

	  	end
	  end
  end
end