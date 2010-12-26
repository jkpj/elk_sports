require 'spec_helper'

describe TimeQuickSave do
  before do
    @race = Factory.create(:race)
    series = Factory.create(:series, :race => @race)
    Factory.create(:competitor, :series => series, :number => 1,
      :start_time => '11:00:00')
    @c = Factory.create(:competitor, :series => series, :number => 10,
      :start_time => '11:30:00', :arrival_time => '12:00:00')
  end

  describe "successfull save" do
    before do
      @qs = TimeQuickSave.new(@race.id, '10:13:12:59')
    end

    describe "#save" do
      it "should save given estimates for the competitor and return true" do
        @qs.save.should be_true
        @c.reload
        @c.arrival_time.strftime('%H:%M:%S').should == '13:12:59'
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
      Factory.create(:competitor, :series => series, :number => 8,
        :start_time => '11:00:00')
      @qs = TimeQuickSave.new(@race.id, '8:13:12:59')
    end

    describe "#save" do
      it "should not save given estimates for the competitor and return false" do
        @qs.save.should be_false
        @c.reload
        @c.arrival_time.strftime('%H:%M:%S').should == '12:00:00'
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
      @qs = TimeQuickSave.new(@race.id, '10:13:12:45:11')
    end

    describe "#save" do
      it "should not save given estimates for the competitor and return false" do
        @qs.save.should be_false
        @c.reload
        @c.arrival_time.strftime('%H:%M:%S').should == '12:00:00'
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
