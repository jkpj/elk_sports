Factory.define :relay do |r|
  r.association :race
  r.start_day 1
  r.name "Men's relay"
  r.legs 4
end