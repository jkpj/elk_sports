Given /^there is a race "([^"]*)"$/ do |name|
  @race = Factory.create(:race, :name => name)
end

Given /^there is a race with attributes:$/ do |fields|
  hash = fields.rows_hash
  if hash[:sport] == 'SKI'
    hash.delete("sport")
    hash[:sport] = Sport.find_ski
  elsif hash[:sport] == 'RUN'
    hash.delete("sport")
    hash[:sport] = Sport.find_run
  elsif hash[:sport]
    raise "Unknown sport key: #{hash[:sport]}"
  end
  @race = Factory.create(:race, hash)
end

Given /^the race "([^"]*)" is renamed to "([^"]*)"$/ do |old_name, new_name|
  race = Race.find_by_name(old_name)
  race.name = new_name
  race.save!
end

Given /^I have a race "([^"]*)"$/ do |name|
  @race = Factory.create(:race, :name => name)
  @user.races << @race
end

Given /^I have a race with attributes:$/ do |fields|
  hash = fields.rows_hash
  if hash[:sport] == 'SKI'
    hash.delete("sport")
    hash[:sport] = Sport.find_ski
  elsif hash[:sport] == 'RUN'
    hash.delete("sport")
    hash[:sport] = Sport.find_run
  elsif hash[:sport]
    raise "Unknown sport key: #{hash[:sport]}"
  end
  @race = Factory.create(:race, hash)
  @user.races << @race
end

Given /^there is an ongoing race with attributes:$/ do |fields|
  @race = Factory.create(:race, {:start_date => Date.today}.merge(fields.rows_hash))
end

Given /^the race is finished$/ do
  @race.reload
  @race.finish!
end

Given /^I have an ongoing race "([^"]*)"$/ do |name|
  @race = Factory.create(:race, :start_date => Date.today, :name => name,
    :sport => Sport.find_ski)
  @user.races << @race
end

Given /^I have an ongoing race with attributes:$/ do |fields|
  @race = Factory.create(:race, {:start_date => Date.today,
    :sport => Sport.find_ski}.merge(fields.rows_hash))
  @user.races << @race
end

Given /^I have a future race "([^"]*)"$/ do |name|
  @race = Factory.create(:race, :start_date => Date.today + 1, :name => name)
  @user.races << @race
end

Given /^I have a complete race "([^"]*)" located in "([^"]*)"$/ do |name, location|
  @race = Factory.create(:race, :name => name, :location => location,
    :start_date => Date.today - 1)
  @user.races << @race
  @race.clubs << Factory.build(:club, :race => @race)
  series = Factory.build(:series, :race => @race, :first_number => 1,
    :start_time => '12:00')
  @race.series << series
  competitor = Factory.build(:competitor, :series => series)
  series.competitors << competitor
  series.generate_start_list! Series::START_LIST_ADDING_ORDER
  competitor.reload
  competitor.shots_total_input = 85
  competitor.estimate1 = 100
  competitor.estimate2 = 150
  competitor.arrival_time = '13:00'
  competitor.save!
  @race.correct_estimates << Factory.build(:correct_estimate, :race => @race,
    :min_number => 1, :max_number => 1)
  @race.set_correct_estimates_for_competitors
  @race.finish!
end