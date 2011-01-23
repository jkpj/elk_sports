at_exit do
  require "irb"
  require "drb/acl"
  #require "sqlite"
end

unless defined?(Ocra)
  system "ruby", "script/rails", "server"
end