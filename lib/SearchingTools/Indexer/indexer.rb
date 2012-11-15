module SearchingTools
  module Indexer
	  class Indexer
	  	class << self
	  		def run(db_name = nil)
	  			Rails.logger.info "Indexing..."
          t1 = Time.now

          hashes = DataAccess::HashAccess.new
          db = db_name ? DataAccess::DbAccess.new(db_name) : DataAccess::DbAccess.new(hashes.database_name)

          Dir.glob("#{hashes.path_to_files}/*.html") do |file|
            parser = Parser.new(file, db, hashes)
            parser.run
            parser.display_variables
          end

          Time.now - t1
	  		end

	  	end
	  end
  end
end