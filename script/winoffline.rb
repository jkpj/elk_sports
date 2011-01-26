#!/usr/bin/env ruby1.8
# This command will automatically be run when you run "rails" with Rails 3 gems installed from the root of your application.

APP_PATH = File.expand_path('../../config/application',  __FILE__)
require File.expand_path('../../config/boot',  __FILE__)
#require 'rails/commands'

# copied from: railties/lib/rails/commands.rb:
require 'rails/commands/server'
Rails::Server.new.tap { |server|
  require APP_PATH
  Dir.chdir(Rails.application.root)
  server.start
}
