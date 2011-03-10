require 'spec_helper'

describe Relay do
  it "create" do
    Factory.create(:relay)
  end
  
  describe "associations" do
    it { should belong_to(:race) }
    it { should have_many(:relay_teams) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should allow_value(nil).for(:start_time) }

    describe "start_day" do
      it { should validate_numericality_of(:start_day) }
      it { should_not allow_value(0).for(:start_day) }
      it { should allow_value(1).for(:start_day) }
      it { should_not allow_value(1.1).for(:start_day) }

      before do
        race = Factory.build(:race)
        race.stub!(:days_count).and_return(2)
        @relay = Factory.build(:relay, :race => race, :start_day => 3)
      end

      it "should not be bigger than race days count" do
        @relay.should have(1).errors_on(:start_day)
      end
    end

    describe "legs" do
      it { should_not allow_value(nil).for(:legs) }
      it { should_not allow_value(0).for(:legs) }
      it { should_not allow_value(1).for(:legs) }
      it { should allow_value(2).for(:legs) }
      it { should_not allow_value(2.1).for(:legs) }
    end
  end
end