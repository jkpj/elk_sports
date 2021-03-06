class TeamCompetition < ActiveRecord::Base
  belongs_to :race
  has_and_belongs_to_many :series, :join_table => 'team_competition_series'
  has_and_belongs_to_many :age_groups, :join_table => 'team_competition_age_groups'

  validates :name, :presence => true
  validates :team_competitor_count, :numericality => { :only_integer => true,
    :greater_than => 1 }

  attr_accessor :temp_series_names, :temp_age_groups_names

  def series_names
    (series.map &:name).join(',')
  end

  def attach_series_by_names(names)
    names.split(',').each do |name|
      series << race.series.find_by_name(name)
    end
  end

  def age_groups_names
    (age_groups.map &:name).join(',')
  end

  def attach_age_groups_by_names(names)
    names.split(',').each do |name|
      age_groups << race.age_groups.find_by_name(name)
    end
  end

  def results
    competitors = []
    series.each do |s|
      competitors += s.competitors.includes([:series, :club, :age_group, :shots])
    end
    age_groups.each do |ag|
      competitors += ag.competitors.where(['series_id NOT IN (?)', (series.map &:id)]).
        includes([:series, :club, :age_group, :shots])
    end
    results_for_competitors competitors
  end

  def results_for_competitors(competitors)
    hash = create_team_results_hash(competitors)
    sorted_teams = sorted_teams_from_team_results_hash(hash)
    remove_teams_without_enough_competitors(sorted_teams)
    sorted_teams
  end

  private
  def create_team_results_hash(competitors)
    # { team1 => {:club => club1, :points => 0, :best_points => 0,
    #             :best_shot_points => 0, :fastest_time => 9999999,
    #             :competitors => []},
    #   team2 => {...} }
    team_results_hash = Hash.new
    competitor_counter = Hash.new

    Competitor.sort(competitors).each do |competitor|
      break if competitor.points.nil? or competitor.unofficial
      competitor_count = competitor_counter[competitor.club] || 0
      if competitor_count < team_competitor_count
        competitor_counter[competitor.club] = competitor_count + 1
        if team_results_hash[competitor.club]
          team_hash = team_results_hash[competitor.club]
          update_team_hash(team_hash, competitor)
        else
          team_results_hash[competitor.club] = create_team_hash(competitor)
        end
      end
    end

    team_results_hash
  end

  def update_team_hash(team_hash, competitor)
    team_hash[:points] += competitor.points
    team_hash[:best_points] = competitor.points if competitor.
      points > team_hash[:points]
    team_hash[:best_shot_points] = competitor.shot_points if competitor.
      points > team_hash[:best_shot_points]
    team_hash[:fastest_time] = competitor.time_in_seconds if competitor.
      time_in_seconds < team_hash[:fastest_time]
    team_hash[:competitors] << competitor
  end

  def create_team_hash(competitor)
    team_hash = Hash.new(:club => competitor.club, :points => 0, :competitors => [])
    team_hash[:club] = competitor.club
    team_hash[:points] = competitor.points
    team_hash[:best_points] = competitor.points
    team_hash[:best_shot_points] = competitor.shot_points
    team_hash[:fastest_time] = competitor.time_in_seconds
    team_hash[:competitors] = [competitor]
    team_hash
  end

  def sorted_teams_from_team_results_hash(hash)
    hash.values.sort do |a, b|
      [b[:points], b[:best_points], b[:best_shot_points], a[:fastest_time]] <=>
        [a[:points], a[:best_points], a[:best_shot_points], b[:fastest_time]]
    end
  end

  def remove_teams_without_enough_competitors(sorted_teams)
    sorted_teams.delete_if { |club| club[:competitors].length < team_competitor_count }
  end
end
