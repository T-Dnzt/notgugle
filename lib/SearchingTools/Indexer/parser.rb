module SearchingTools
  module Indexer
	class Parser

	  	def initialize(path, tags_weight, excluded_words)
	  		@path = path
	  		@tags_weight = tags_weight
	  		@excluded_words = excluded_words
	  	end

	  	#Create a new page in db and start to parse if the page has been modified
	  	def run
	  	  @path.each do |dir|
			Dir.glob("#{dir}/*.html") do |file|					
			  if page = save_page(file)
				doc = Nokogiri::HTML(open(file))	
				parse_page(page, doc)
			  end
			end
		  end
		end

private

		#Parse each html file in the specified directory
		def parse_page(page, doc)
		  @tags_weight.each do |tag, weight|
			doc.xpath("//#{tag}").each do |node|
		  	  parse_node(node).each do |word|
		  		save_word(page.id, word, tag.to_s) unless @excluded_words.include?(word.downcase)
		  	  end
		    end
		  end
		end

		#Parse each tag to retrieve the word. Split everything which is not a letter or a space.
		def parse_node(node)
		  words = node.text.split(' ').each {|w| w.gsub!(/(\W|\d)/, "")}
		end

		#Calculate the weight of the current word based on the stats attribute
		def calc_weight(stats)
		  weight = stats.inject(0) {|sum, hash| sum + (@tags_weight[hash[:tag].to_sym].to_f * hash[:frequency].to_f) }
		end

		#Save or update a page in db. Check the md5 to see if anything changed
		def save_page(file)
		  filename = File.basename(file)
		  file_hash = Digest::MD5.hexdigest(File.read(file))
			
		  if page = Page.find_by_filename(filename)
			if file_hash == page.file_hash
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

		#Save or update a word in db. 
		def save_word(page_id, word, tag)
		  page = Page.find(page_id)
		  page_keywords = page.keywords.collect { |k| k.word }

		  if page_keywords.include?(word.downcase)
			keyword = Keyword.find_by_page_id_and_word(page.id, word.downcase)
			update_keyword_stats(keyword, tag)		
		  else
		  	stats = [{:tag => tag, :frequency => 1}]
			Keyword.create(:page => page,
						   :word => word.downcase,
						   :weight => calc_weight(stats),
						   :stats => stats)
		  end
	  	end 

	  	#Update the stats of the keyword parameter.
	  	def update_keyword_stats(keyword, tag)
			stats = keyword.stats.each { |hash| hash.to_options! }

			if current_stat = stats.find { |hash| hash[:tag] == tag}
				stats.delete(current_stat)
				current_stat[:frequency] += 1
				stats << current_stat
				keyword.update_attributes(:stats => stats,
										  :weight => calc_weight(stats))
			else
				stats << {:tag => tag, :frequency => 1}
				keyword.update_attributes(:stats => stats,
										  :weight => calc_weight(stats))
			end
		end	
	end
  end
end