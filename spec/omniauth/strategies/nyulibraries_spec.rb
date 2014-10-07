require 'spec_helper'
module OmniAuth
  module Strategies
    describe Nyulibraries do
      context "when the configuration comes correct" do
        let(:config) { {} }
        let(:response) do
          double("response", parsed: {
              "username" => "username",
              "email" => "email",
              "provider" => "provider",
              "identities" => "identities",
              "institution_code" => "institution_code"
            })
        end
        let(:access_token) { double('access_token', :get => response) }
        subject(:strategy) do
          OmniAuth::Strategies::Nyulibraries.new(nil, config).tap do |strategy|
            allow(strategy).to receive(:access_token) {
              access_token
            }
          end
        end
        describe '#name' do
          subject { strategy.name }
          it { should_not be_nil }
          it { should eq(:nyulibraries) }
        end
        describe '#options' do
          subject(:options) { strategy.options }
          it { should_not be_nil }
          it { should be_a(Hash) }
          it { should_not be_empty }
          describe '#client_options' do
            subject { options.client_options }
            it { should_not be_nil }
            it { should be_a(Hash) }
            it { should_not be_empty }
            context "when default" do
              it { should eq({ "site" => "https://dev.login.library.nyu.edu",
                "authorize_path" => "/oauth/authorize" }) }
            end
            context "when production" do
              let(:config) do
                { client_options: { site: "https://login.library.nyu.edu" } }
              end
              it { should eq({ "site" => "https://login.library.nyu.edu",
                "authorize_path" => "/oauth/authorize" }) }
            end
          end
        end
        describe 'uid' do
          subject(:uid) {strategy.uid}
          it { should_not be_nil }
          it { should eq("username")}
        end
        describe 'info' do
          subject(:info) {strategy.info}
          it { should_not be_nil }
          it { should be_a(Hash) }
          it { should eq({
              name: "username",
              nickname: "username",
              email: "email"
            })}
        end
        describe 'extra' do
          subject(:extra) {strategy.extra}
          it { should_not be_nil }
          it { should be_a(Hash) }
          it { should eq({
              provider: "provider",
              identities: "identities",
              institution_code: "institution_code"
            })}
        end
        describe 'raw_info' do
          subject(:raw_info) {strategy.raw_info}
          it { should_not be_nil }
          it { should be_a(Hash) }
          it { should eq({
              "username" => "username",
              "email" => "email",
              "provider" => "provider",
              "identities" => "identities",
              "institution_code" => "institution_code"
            })}
        end
      end
      context "when the strategy is used as middleware" do
        let(:application_id)      { ENV["NYULIBRARIES_APPLICATION_ID"] }
        let(:application_secret)  { ENV["NYULIBRARIES_APPLICATION_SECRET"] }
        let(:app) do
          args = [application_id, application_secret]
          Rack::Builder.new {
            use OmniAuth::Test::PhonySession
            use OmniAuth::Strategies::Nyulibraries, *args
            run lambda { |env| [404, {'Content-Type' => 'text/plain'}, [env.key?('omniauth.auth').to_s]] }
          }.to_app
        end
        let(:session) { last_request.env['rack.session'] }
        let(:callback) {last_request.env["omniauth.strategy"].callback_url}
        describe '/auth/nyulibraries' do
          before(:each){ get '/auth/nyulibraries' }
          let(:login_authorization) do
            "https://dev.login.library.nyu.edu/oauth/authorize?client_id=#{application_id}"+
              "&redirect_uri=http%3A%2F%2Fexample.org%2Fauth%2Fnyulibraries%2Fcallback&"+
                "response_type=code&"
          end
          it 'should redirect to login authorization' do
            expect(last_response).to be_redirect
            expect(last_response.status).to be(302)
            expect(last_response.location).to start_with(login_authorization)
          end
          it 'should have a callback url' do
            expect(callback).to eq("http://example.org/auth/nyulibraries/callback")
          end
        end
      end
    end
  end
end
