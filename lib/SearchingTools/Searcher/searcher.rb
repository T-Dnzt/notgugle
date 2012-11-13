module SearchingTools
  module Searcher
    class Searcher
  	  class << self
  		def run(searched_str)
  			Rails.logger.info "Searching..."
  			searched_arr = searched_str.split(' ').each {|w| w.gsub!(/[^[:alpha:]]/, "")}

  			result_pages = Hash.new(0)

        db = Mongo::Connection.new.db('notgugle-development')
        words_collection = db.collection("keywords")
  			searched_arr.each do |word|
  			  matches = words_collection.find({'word' => /#{word}/i}).to_a

          pages = []
          matches.each {|match| match["pages"].each { |p| pages << p } }
          result_pages = sum_weight(get_result_pages(pages, "filename"))
  			end

        result_pages.sort! {|a, b| b["weight"] <=> a["weight"] }
  			result_pages
  		end

      def sum_weight(array)
        array.each do |hash|
          hash["weight"] = hash["weight"].inject{|sum,x| sum + x } if hash["weight"].class == Array
        end
        array
      end

      def get_result_pages(array, id)
        array.group_by {|row| row[id] }.collect do |k,v|
          keys = v.collect {|rec| rec.keys}.flatten.uniq
          group = {}
          keys.each do |key|
            vals = v.collect { |rec| rec[key] }.uniq.compact
            group[key] = vals.size > 1 ? vals : vals.first
          end
          group
        end
      end

  		def excluded_words
  			%w{le la les}
      end


  	  end
  	end
  end
end