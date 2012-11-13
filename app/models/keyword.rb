class Keyword
  include MongoMapper::Document

  many :pages

  key :word, String

  self.ensure_index(:word)
end

class Page
  include MongoMapper::EmbeddedDocument

  key :filename, String
  key :weight, Float
  key :frequency, Integer

  self.ensure_index([:filename, 1], [:weight, -1])

end
