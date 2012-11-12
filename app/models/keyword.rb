class Keyword
  include MongoMapper::Document

  belongs_to :page

  key :word, String
  key :weight, Float
  key :stats, Array
  timestamps!

  self.ensure_index(:word)

end
