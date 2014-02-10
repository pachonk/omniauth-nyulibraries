$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!
require 'rspec'
require 'rack/test'
require 'omniauth'
require 'omniauth-nyulibraries'
require 'pry'

def application_id
  @application_id ||= ENV["NYULIBRARIES_APPLICATION_ID"]
end

def application_secret
  @application_secret ||= ENV["NYULIBRARIES_APPLICATION_SECRET"]
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend OmniAuth::Test::StrategyMacros, :type => :strategy
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
