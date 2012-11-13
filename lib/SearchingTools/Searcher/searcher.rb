module SearchingTools
  module Searcher
    class Searcher
  	  class << self
  		def run(searched_str)
  			Rails.logger.info "Searching..."
  			searched_arr = searched_str.split(' ').each {|w| w.gsub!(/[^[:alpha:]]/, "")}

  			result_pages = []

        db = Mongo::Connection.new.db('notgugle-development')
        words_collection = db.collection("keywords")
  			searched_arr.each do |word|
          Rails.logger.info "Looking for #{word}"
  			  matches = words_collection.find({'word' => /#{word}/i}).to_a
          Rails.logger.info "Matches : #{matches.inspect}"
          matches.each do |match|
            
            pages = match["pages"].sort! { |a,b| b["weight"] <=> a["weight"] }

            pages.each {|page| result_pages << page }
          end
  			end


  			Rails.logger.debug "Results :"
  			result_pages.each {|r| Rails.logger.debug "#{r}"}
  			result_pages
  		end


  		def excluded_words
  			%w{le la les}
  		end
  	  end
  	end
  end
end