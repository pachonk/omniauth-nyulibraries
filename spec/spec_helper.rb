$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
if RUBY_VERSION >= '2.0.0'
  require 'coveralls'
  Coveralls.wear!
end
require 'rspec'
require 'rack/test'
require 'omniauth'
require 'omniauth-nyulibraries'
require 'pry'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend OmniAuth::Test::StrategyMacros, :type => :strategy
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
