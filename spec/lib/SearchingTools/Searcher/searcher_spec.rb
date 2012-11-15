require File.expand_path(File.dirname(__FILE__) + '../../../../spec_helper')
Dir[Rails.root + 'lib/**/*.rb'].each {|lib| require lib }


describe SearchingTools::Indexer::Parser do

  before :all do
    hashes = SearchingTools::DataAccess::HashAccess.new
    rspec_test = Rails.root.join('public/html/rspec_test.html')
    source_file = Rails.root.join('public/html/test.html')
    system "cp #{source_file} #{rspec_test}"

    @db = SearchingTools::DataAccess::DbAccess.new("notgugle-test") 
    @parser = SearchingTools::Indexer::Parser.new(rspec_test, @db, hashes )
  end

  before :each do
    @db.keywords.remove()
    @db.html_files.remove()
  end


  describe "Search" do
    it "should return results" do 
      @parser.run
      results = SearchingTools::Searcher::Searcher.run(@db.keywords.find.to_a.first["word"])
      results.should_not eq(nil)
      results["pages"].count.should > 0
      results["pages"].each do |page|
        page["filename"].should_not be_nil
        page["weight"].should > 0
        page["frequency"].count.should > 0
        page["words"].count.should > 0
      end
    end
  end

end