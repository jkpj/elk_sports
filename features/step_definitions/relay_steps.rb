Given /^the race has a relay "([^*]*)"$/ do |name|
  @relay = Factory.create(:relay, :race => @race, :name => name)
end

Given /^the race has a relay with attributes:$/ do |table|
  @relay = Factory.create(:relay, {:race => @race}.merge(table.rows_hash))
end

Given /^the relay has a team "([^"]*)"$/ do |name|
  @relay_team = Factory.create(:relay_team, :relay => @relay, :name => name)
end

Given /^the relay has a team "([^"]*)" with number (\d+)$/ do |name, number|
  @relay_team = Factory.create(:relay_team, :relay => @relay, :name => name, :number => number)
end

Given /^the relay team has a competitor with attributes:$/ do |table|
  Factory.create(:relay_competitor, {:relay_team => @relay_team}.merge(table.rows_hash))
end

Given /^the estimate for the relay competitor "([^"]*)" "([^"]*)" is (\d+)$/ do |first,
    last, estimate|
  competitor = RelayCompetitor.where(:first_name => first, :last_name => last).first
  competitor.estimate = estimate
  competitor.save!
end

Given /^the relay has the correct estimates:$/ do |table|
  table.hashes.each do |hash|
    Factory.create(:relay_correct_estimate, :relay => @relay,
      :leg => hash[:leg], :distance => hash[:distance])
  end
end

Given /^the relay is finished$/ do
  @relay.finish!
end
