# roles, users
Role.create!(:name => Role::ADMIN)
Role.create!(:name => Role::OFFICIAL)

admin = User.create!(:email => 'admin@admin.com', :password => 'admin',
  :password_confirmation => 'admin', :first_name => 'Antti', :last_name => 'Admin')
admin.add_admin_rights

user = User.create!(:email => 'user@user.com', :password => 'user',
  :password_confirmation => 'user', :first_name => 'Timo', :last_name => 'Toimitsija')
user.add_official_rights

# sports
run = Sport.create!(:name => "Hirvenjuoksu", :key => "RUN")
ski = Sport.create!(:name => "Hirvenhiihto", :key => "SKI")

# races
race1 = run.races.build(:name => "P-Savon hirvenjuoksukisat",
  :location => "Tervo", :start_date => '2010-08-14')
race1.save!
race2 = ski.races.build(:name => "P-Savon hirvenhiihtokisat",
  :location => "Karttula", :start_date => '2010-12-13')
race2.save!

# series
correct1 = 100
correct2 = 140
s1 = race1.series.build(:name => "Miehet yli 50v", :correct_estimate1 => correct1,
  :correct_estimate2 => correct2)
s1.save!

# competitors
club_places = ["Vähälän", "Jokikylän", "Keski-Suomen", "Etelä-Savon", "Metsälän"]
club_suffixes = ["piiri", "ampumaseura"]
firsts = ["Matti", "Teppo", "Pekka", "Timo", "Jouni", "Heikki"]
lasts = ["Heikkinen", "Räsänen", "Miettinen", "Savolainen", "Raitala"]
10.times do |i|
  first = firsts[i % firsts.length]
  last = lasts[i % lasts.length]
  club_name = "#{club_places[i % club_places.length]} #{club_suffixes[i % club_suffixes.length]}"
  club = Club.create!(:name => club_name)
  arrival = "15:0#{i + 1}:3#{9 - i}" unless i == 7
  comp = s1.competitors.build(:first_name => first, :last_name => last,
    :year_of_birth => 1960 + i, :club => club, :number => 100 + i,
    :start_time => "14:00:0#{i}", :arrival_time => arrival)
  if i % 4 == 0
    comp.shots << Shot.new(:competitor => comp, :value => 10)
    comp.shots << Shot.new(:competitor => comp, :value => 3)
    comp.shots << Shot.new(:competitor => comp, :value => 0)
    comp.shots << Shot.new(:competitor => comp, :value => 7)
    comp.shots << Shot.new(:competitor => comp, :value => 10)
    comp.shots << Shot.new(:competitor => comp, :value => 7)
    comp.shots << Shot.new(:competitor => comp, :value => 9)
    comp.shots << Shot.new(:competitor => comp, :value => 9)
    comp.shots << Shot.new(:competitor => comp, :value => 2)
    comp.shots << Shot.new(:competitor => comp, :value => 10)
  else
    shots = 71 + 2 * i
    shots = nil if i == 3 or i == 7
    comp.shots_total_input = shots
  end
  comp.estimate1 = correct1 + 6 - i
  comp.estimate2 = correct2 - 8 + 2 * 1
  if i == 1
    comp.estimate1 = nil
  elsif i == 3
    comp.estimate2 = nil
  elsif i == 6
    comp.estimate2 = correct2 + 1
  end
  comp.save!
end