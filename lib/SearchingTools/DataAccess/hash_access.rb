module SearchingTools
  module DataAccess
    class HashAccess

        def initialize(options = {})
          #load files in hashes
        end

        def tags_weights
          {
              "p" => 1,
              "h1" => 3,
              "h2" => 1.5,
              "h3" => 1.4,
              "h4" => 1.3,
              "h5" => 1.2,
              "h6" => 1.1,
              "strong" => 2,
              "a" => 1.1,
              "link" => 4,
          }
        end

        def special_tags_weights
          {
              "meta[@name='keywords']" => ['content', 1],
              "meta[@name='description']" => ['content', 2],
              "img[@alt]" => ['alt', 1.2],
              "a[@title]" => ['title', 1.1]
          }
        end

        def excluded_words_index
          %w{le la les je tu il elle nous vous elles ils leur leurs la mes ma mon mais ou est donc or ni car ni si un une des a b c d e f g h i j k l m n o p q r s t u v w x y z }
        end

        def excluded_words_search
        %w{le la les je tu il elle nous vous elles ils leur leurs la mes ma mon mais ou est donc or ni car ni si un une des a b c d e f g h i j k l m n o p q r s t u v w x y z }
      end

    end
  end
end