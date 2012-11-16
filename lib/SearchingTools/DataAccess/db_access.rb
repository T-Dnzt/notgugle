#This class is used to access the mongodb database and retrieve specific values
module SearchingTools
  module DataAccess
    class DbAccess

      def initialize(db_name)
        @db = Mongo::Connection.new.db(db_name)
      end

      def keywords
        @db.collection("keywords")
      end

      def html_files
        @db.collection("html_files")
      end

      def find_html_file(filename)
        html_files.find_one({'filename' => filename})
      end

      def find_word(word)
        keywords.find_one({ 'word' => word })
      end

      def check_or_update_if_file_changed(file, filename, file_hash)
        if file_hash == file["file_hash"]
          false
        else
          html_files.update({'filename' => filename }, { 'filename' => filename, 'file_hash' => file_hash})
          true
        end
      end

      def create_html_file(filename, file_hash)
        html_files.insert({ 'filename' => filename, 'file_hash' => file_hash })
        true
      end

      def update_or_create_word(word, filename, weight, frequency)
        keywords.update({ 'word' => word }, {'$addToSet' => { 'pages' => { 'filename' => filename, 'weight' => weight, 'frequency' => frequency }}}, :upsert => true)
      end

      #Remove the file named 'filename' from every document in the database
      def flush_page(word_weight, filename, file_changed)
        word_weight.each do |word, weight|
          if file_changed && existing_word = find_word(word)
            existing_word["pages"].delete_if { |h| h["filename"] == filename }
            keywords.save(existing_word)
          end
        end
      end
      

    end
  end
end