module SearchingTools
  module Indexer
	  class Parser

	  	def initialize(file, tags_weight, excluded_words)
	  		@file = file
	  		@tags_weight = tags_weight
	  		@excluded_words = excluded_words
    		@word_weight = Hash.new(0)
    		@word_frequency = Hash.new(0)
    		@db = Mongo::Connection.new.db('notgugle-development')
	  	end

	  	#Create a new page in db and start to parse if the page has been modified
	  	def run
				if save_page
					doc = Nokogiri::HTML(open(@file,"r"))
					parse_page(doc)
			  end
			  save_words
			end

private

		#Parse each html file in the specified directory
		def parse_page(doc)
		  @tags_weight.each do |tag, weight|
			  doc.xpath("//#{tag}").each do |node|
		  	  parse_node(node, weight)
		    end
		  end
		end

		#Parse each tag to retrieve the word. Split everything which is not a letter or a space.
		def parse_node(node, weight)
		  node.text.gsub(/[^[:alpha:]]/, " ").downcase.split.each do |word|		  	
		  	if word.length > 1 && !@excluded_words.include?(word)
          @word_weight[word] += weight
          @word_frequency[word] += 1
        end
		  end
		end

		def save_words
			 word_collection = @db.collection("keywords")
		   @word_weight.each do |k, v|
		     word_collection.update({ 'word' => "#{k}" }, {'$addToSet' => { 'pages' => { 'filename' => File.basename(@file), 'weight' => v, 'frequency' => @word_frequency[k] }}}, :upsert => true)
		   end
		end

		#Save or update a page in db. Check the md5 to see if anything changed
		def save_page
			filename = File.basename(@file)
			pages_collection = @db.collection("pages")
    	file_hash = Digest::MD5.hexdigest(File.read(@file))
	    if file = HtmlFile.find(filename: filename)
	      if file_hash == file.file_hash
	      	nil
	      else
	      	pages_collection.update({'filename' => filename }, { 'file_hash' => file_hash})
	      	true
	      end
	    else
	    	pages_collection.insert({ 'filename' => filename, 'file_hash' => file_hash })
	    	true
	    end
		end

	 end
  end
end