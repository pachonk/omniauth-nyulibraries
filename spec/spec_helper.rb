$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!
require 'rspec'
require 'rack/test'
require 'vcr'
require 'faraday'
require 'omniauth'
require 'omniauth-nyulibraries'
require 'pry'

def application_id
  @application_id ||= ENV["NYULIBRARIES_APPLICATION_ID"]
end

def application_secret
  @application_secret ||= ENV["NYULIBRARIES_APPLICATION_SECRET"]
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend OmniAuth::Test::StrategyMacros, :type => :strategy
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  # so we can use :vcr rather than :vcr => true;
  # in RSpec 3 this will no longer be necessary.
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
