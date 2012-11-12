class Page
  include MongoMapper::Document

  many :keywords

  key :filename, String
  key :file_hash, String
  timestamps!

  self.ensure_index(:_id)

end
