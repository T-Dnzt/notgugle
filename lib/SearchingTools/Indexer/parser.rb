module SearchingTools
  module Indexer
	  class Parser

	  	def initialize(file, tags_weight, excluded_words)
	  		@file = file
	  		@page = nil
	  		@tags_weight = tags_weight
	  		@excluded_words = excluded_words
    		@word_collection = Mongo::Connection.new.db('notgugle-development').collection("keywords")
    		@page_collection = Mongo::Connection.new.db('notgugle-development').collection("pages")
	  	end

	  	#Create a new page in db and start to parse if the page has been modified
	  	def run
				if page = save_page
					@page = page
					doc = Nokogiri::HTML(open(@file))
					parse_page(doc)
			  end
			end

private

		#Parse each html file in the specified directory
		def parse_page(doc)
		  @tags_weight.each do |tag, weight|
			  doc.xpath("//#{tag}").each do |node|
		  	  parse_node(node, tag)
		    end
		  end
		end

		#Parse each tag to retrieve the word. Split everything which is not a letter or a space.
		def parse_node(node, tag)
		  node.text.gsub(/[^[:alpha:]]/, " ").downcase.split.each do |word|
		  	if !word.blank? && !@excluded_words.include?(word)
		  		save_word(word, tag)
        end
		  end
		end

		def save_word(word, tag)
			if keyword = Keyword.find_by_word_and_page_id(word, @page.id)
				keyword["weight"] += @tags_weight[tag].to_f
				keyword.save
			else
				@word_collection.insert({'page_id' => @page.id, 'word' => word, 'weight' => 0})
			end	
		end

		#Save or update a page in db. Check the md5 to see if anything changed
		def save_page
			filename = File.basename(@file)
    	file_hash = Digest::MD5.hexdigest(File.read(@file))
	    if page = Page.find_by_filename(filename)
	      if file_hash == page.file_hash
	      	@page = nil
	      	nil
	      else
	      	page.update_attribute(:file_hash, file_hash)
	      	page
	      end
	    else
	      Page.create(:filename => filename,
	                  :file_hash => file_hash)
	    end  
		end

	 end
  end
end