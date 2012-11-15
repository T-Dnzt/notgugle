require File.expand_path(File.dirname(__FILE__) + '../../../../spec_helper')
Dir[Rails.root + 'lib/**/*.rb'].each {|lib| require lib }

describe SearchingTools::Indexer::Indexer do

  describe "Indexing" do
    it "should return the timer without errors" do
      timer = SearchingTools::Indexer::Indexer.run("notgugle-test")
      timer.should_not eq(nil)
      timer.should > 0
    end
  end

end