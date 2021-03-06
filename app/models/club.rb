class Club < ActiveRecord::Base
  default_scope :order => :name

  belongs_to :race
  has_many :competitors

  validates :name, :presence => true, :uniqueness => { :scope => :race_id }

  before_destroy :check_competitors

  private
  def check_competitors
    unless competitors.empty?
      errors.add(:base, 'Seuraa ei voi poistaa, koska sillä on kilpailijoita')
      return false
    end
  end
end
