require 'spec_helper'

describe RelayMissesQuickSave do
  before do
    @race = Factory.create(:race)
    @relay = Factory.create(:relay, :race => @race, :legs_count => 2)
    @team = Factory.create(:relay_team, :relay => @relay, :number => 5)
    @c = Factory.create(:relay_competitor, :relay_team => @team, :leg => 2,
      :misses => 3)
  end

  it "should save the misses when competitor found and valid misses" do
    @qs = RelayMissesQuickSave.new(@relay.id, '5,2,1')
    @qs.save.should be_true
    @qs.competitor.should == @c
    @qs.error.should be_nil
    @c.reload
    @c.misses.should == 1
  end

  it "should handle error when invalid misses" do
    @qs = RelayMissesQuickSave.new(@relay.id, '5,2,6')
    check_failure true
  end

  it "should handle error when unknown leg number" do
    @qs = RelayMissesQuickSave.new(@relay.id, '5,1,1')
    check_failure
  end

  it "should handle error when unknown team number" do
    @qs = RelayMissesQuickSave.new(@relay.id, '4,2,1')
    check_failure
  end

  it "should handle error when invalid string format" do
    @qs = RelayMissesQuickSave.new(@relay.id, '5,x2,1')
    check_failure
  end

  def check_failure(competitor=false)
    @qs.save.should be_false
    @qs.error.should_not be_nil
    @qs.competitor.should == @c if competitor
    @qs.competitor.should be_nil unless competitor
    @c.reload
    @c.misses.should == 3
  end
end

