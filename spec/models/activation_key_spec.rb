require 'spec_helper'

describe ActivationKey do
  describe "validations" do
    it { should validate_presence_of(:comment) }
  end

  describe "#valid?" do
    it "should return false with wrong parameters" do
      ActivationKey.valid?('some@email.com', 'mypass', 'mykey').should be_false
    end

    it "should return true with correct parameters (lower case)" do
      ActivationKey.valid?('online@hirviurheilu.com', 'online', '5bd11fe7d2').should be_true
    end

    it "should return true with correct parameters (upper case)" do
      ActivationKey.valid?('online@hirviurheilu.com', 'online', '5BD11FE7D2').should be_true
    end
  end
end

