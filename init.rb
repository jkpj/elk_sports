at_exit do
  require "irb"
  require "drb/acl"
  #require "sqlite"
end

system "rails", "server" unless ENV['BUILD_EXE']