require 'spec_helper'

describe EstimatesQuickSave do
  before do
    @race = Factory.create(:race)
    series = Factory.create(:series, :race => @race)
    Factory.create(:competitor, :series => series, :number => 1)
    @c = Factory.create(:competitor, :series => series, :number => 10,
      :estimate1 => 1, :estimate2 => 2)
  end

  describe "successfull save" do
    before do
      @qs = EstimatesQuickSave.new(@race.id, '10:98:115')
    end

    describe "#save" do
      it "should save given estimates for the competitor and return true" do
        @qs.save.should be_true
        @c.reload
        @c.estimate1.should == 98
        @c.estimate2.should == 115
      end
    end

    describe "#competitor" do
      it "should return the correct competitor" do
        @qs.save
        @c.reload
        @qs.competitor.should == @c
      end
    end

    describe "#error" do
      it "should be nil" do
        @qs.save
        @qs.error.should be_nil
      end
    end
  end

  describe "unknown competitor" do
    before do
      another_race = Factory.create(:race)
      series = Factory.create(:series, :race => another_race)
      Factory.create(:competitor, :series => series, :number => 8)
      @qs = EstimatesQuickSave.new(@race.id, '8:98:115')
    end

    describe "#save" do
      it "should not save given estimates for the competitor and return false" do
        @qs.save.should be_false
        @c.reload
        @c.estimate1.should == 1
        @c.estimate2.should == 2
      end
    end

    describe "#competitor" do
      it "should return nil" do
        @qs.save
        @qs.competitor.should be_nil
      end
    end

    describe "#error" do
      it "should contain competitor error message" do
        @qs.save
        @qs.error.should match(/kilpailija/)
      end
    end
  end

  describe "invalid string format" do
    before do
      @qs = EstimatesQuickSave.new(@race.id, '8:98:')
    end

    describe "#save" do
      it "should not save given estimates for the competitor and return false" do
        @qs.save.should be_false
        @c.reload
        @c.estimate1.should == 1
        @c.estimate2.should == 2
      end
    end

    describe "#competitor" do
      it "should return nil" do
        @qs.save
        @qs.competitor.should be_nil
      end
    end

    describe "#error" do
      it "should contain invalid format error message" do
        @qs.save
        @qs.error.should match(/muoto/)
      end
    end
  end
end
