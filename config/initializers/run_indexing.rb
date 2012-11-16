Dir[Rails.root + 'lib/**/*.rb'].each do |lib|
  require lib
end 

timer = SearchingTools::Indexer::Indexer.run
p "Indexing finished in : #{timer} s"