module SearchingTools
  module Searcher
    class Searcher
  	  class << self
  		def run(searched_str)
  			Rails.logger.info "Searching..."
  			searched_arr = searched_str.gsub!(Regexp.new(excluded_words)).split(' ')

  			searched_arr.each do |word|
  			  matches = Keyword.find_all_by_word(word)
  			  matches.each do |match|
  			  	
  			  end
  			end
  		end


  		def excluded_words
  			%w{le la les}
  		end
  	  end
  	end
  end
end