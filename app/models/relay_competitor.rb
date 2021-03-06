class RelayCompetitor < ActiveRecord::Base
  belongs_to :relay_team

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :misses, :numericality => { :only_integer => true, :allow_nil => true,
    :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5 }
  validates :estimate, :numericality => { :only_integer => true, :allow_nil => true,
    :greater_than => 0 }
  validates :adjustment, :numericality => { :only_integer => true, :allow_nil => true }
  validates :leg, :numericality => { :only_integer => true, :greater_than => 0 },
    :uniqueness => { :scope => :relay_team_id }
  validate :leg_not_bigger_than_relay_legs_count
  validate :arrival_not_before_start_time

  before_validation :set_start_time
  after_update :set_next_competitor_start_time

  def previous_competitor
    return nil if leg == 1
    relay_team.relay_competitors.where(:leg => leg - 1).first
  end

  def next_competitor
    return nil if leg == relay_team.relay.legs_count
    relay_team.relay_competitors.where(:leg => leg + 1).first
  end

  def estimate_penalties
    return nil unless estimate
    correct_estimate = relay_team.relay.correct_estimate(leg)
    return nil unless correct_estimate
    diff = (correct_estimate - estimate).abs
    return 0 if diff == 0
    penalties = (diff - 1) / 5
    return 5 if penalties > 5
    penalties
  end

  def time_in_seconds
    return nil if start_time.nil? or arrival_time.nil?
    arrival_time - start_time + adjustment.to_i
  end

  private
  def leg_not_bigger_than_relay_legs_count
    if relay_team and leg > relay_team.relay.legs_count
      errors.add(:leg, 'ei voi olla suurempi kuin viestin osuuksien määrä')
    end
  end

  def arrival_not_before_start_time
    return if start_time.nil? and arrival_time.nil?
    if start_time.nil?
      errors.add(:base,
        'Kilpailijalla ei voi olla saapumisaikaa, jos hänellä ei ole lähtöaikaa')
      return
    end
    if arrival_time and start_time >= arrival_time
      errors.add(:arrival_time, "pitää olla lähtöajan jälkeen")
    end
  end

  def set_start_time
    return unless relay_team
    if leg == 1
      self.start_time = relay_team.relay.start_time
    else
      prev = previous_competitor
      self.start_time = prev.arrival_time if prev
    end
  end

  def set_next_competitor_start_time
    comp = next_competitor
    if comp
      comp.start_time = arrival_time
      comp.save!
    end
  end
end
