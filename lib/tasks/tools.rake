Dir[Rails.root + 'lib/**/*.rb'].each do |lib|
      require lib
end

namespace :tools do

  desc "Index the files"
  task :index  => :environment do
    timer = SearchingTools::Indexer::Indexer.run
    p "Indexing finished in #{timer} s"
  end

  task :search, [:search] => :environment do
    raise "Missing paramter searche." unless ENV["search"]
    results = SearchingTools::Searcher::Searcher.run(ENV["search"])
    p "Search finished in #{results['timer']} for word : #{ENV["search"]}"
    results["pages"].each do |page|
      p "Result page : #{page['filename']} with weight #{page['weight']}"
    end
  end

end