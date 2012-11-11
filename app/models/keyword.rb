class Keyword
  include MongoMapper::Document

  belongs_to :page

  key :word, String
  key :weight, Integer
  key :stats, Array
end
