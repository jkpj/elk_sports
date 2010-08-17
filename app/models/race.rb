class Race < ActiveRecord::Base
  belongs_to :sport
  has_many :series

  validates :name, :presence => true
  validates :location, :presence => true
  validates :start_date, :presence => true
end