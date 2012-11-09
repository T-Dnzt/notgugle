class Keyword
  include MongoMapper::Document

  belongs_to :page

  key :weight, Integer
  key :stats, Array
end
