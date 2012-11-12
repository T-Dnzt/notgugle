module SearchingTools
  module Searcher
    class Searcher
  	  class << self
  		def run(searched_str)
  			Rails.logger.info "Searching..."
  			searched_arr = searched_str.split(' ').each {|w| w.gsub!(/[^[:alpha:]]/, "")}

  			result_pages = []
  			searched_arr.each do |word|
  			  matches = Keyword.find_all_by_word(Regexp.new(word))

  			  matches.sort! { |a,b| b.weight <=> a.weight }
  			  matches.each {|match| result_pages << match.page }
  			end
  			Rails.logger.debug "Results :"
  			result_pages.each {|r| Rails.logger.debug "#{r.filename}"}
  			result_pages
  		end


  		def excluded_words
  			%w{le la les}
  		end
  	  end
  	end
  end
end