Given /^the series has a competitor$/ do
  @competitor = Factory.create(:competitor, :series => @series)
end

Given /^the series has a competitor with attributes:$/ do |fields|
  hash = fields.rows_hash
  if hash[:club]
    club = Club.find_by_name(hash[:club])
    hash[:club] = club
  end
  @competitor = Factory.create(:competitor, {:series => @series}.merge(hash))
end

Given /^the competitor "([^"]*)" "([^"]*)" has the following results:$/ do |first_name,
    last_name, fields|
  competitor = Competitor.where(['first_name=? and last_name=?', first_name, last_name]).first
  competitor.attributes = fields.rows_hash
  competitor.save!
end

Given /^the shots for the competitor "([^"]*)" "([^"]*)" are (\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+),(\d+)$/ do |first_name,
    last_name, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10|
  competitor = Competitor.where(['first_name=? and last_name=?', first_name, last_name]).first
  competitor.shots << Shot.new(:value => s1)
  competitor.shots << Shot.new(:value => s2)
  competitor.shots << Shot.new(:value => s3)
  competitor.shots << Shot.new(:value => s4)
  competitor.shots << Shot.new(:value => s5)
  competitor.shots << Shot.new(:value => s6)
  competitor.shots << Shot.new(:value => s7)
  competitor.shots << Shot.new(:value => s8)
  competitor.shots << Shot.new(:value => s9)
  competitor.shots << Shot.new(:value => s10)
end
