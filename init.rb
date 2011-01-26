at_exit do
  require "irb"
  require "drb/acl"
  #require "sqlite"
end

unless defined?(Ocra)
  p "KAYNNISTETAAN HIRVIURHEILU..."
  load "script/winoffline.rb"
end