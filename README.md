# OmniAuth NYU Libraries
[![Build Status](https://api.travis-ci.org/NYULibraries/omniauth-nyulibraries.png?branch=master)](https://travis-ci.org/NYULibraries/omniauth-nyulibraries)
[![Dependency Status](https://gemnasium.com/NYULibraries/omniauth-nyulibraries.png)](https://gemnasium.com/NYULibraries/omniauth-nyulibraries)
[![Code Climate](https://codeclimate.com/github/NYULibraries/omniauth-nyulibraries.png)](https://codeclimate.com/github/NYULibraries/omniauth-nyulibraries)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/omniauth-nyulibraries/badge.png?branch=master)](https://coveralls.io/r/NYULibraries/omniauth-nyulibraries)

OmniAuth strategy for the NYU Libraries OAuth2 provider

# Installation
## Gemfile
In your Gemfile add:

```ruby
gem 'omniauth-nyulibraries'
```

Then run `bundle install`

## Config

Go to the __config > initializers__ directory and locate __omniauth.rb__, where you will have to add the following:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :nyulibraries, YOUR_APP_KEY, YOUR_APP_SECRET, :client_options =>  {:site => LOGIN_URL}
end
```

If you are using [Devise](https://github.com/plataformatec/devise), go to the __config > initializers__ directory and locate __devise.rb__, where you will have to add the following:

```ruby
Devise.setup do |config|
#...
#ADD THIS LINE
config.omniauth :nyulibraries,  YOUR_APP_KEY, YOUR_APP_SECRET, :client_options =>  {:site => LOGIN_URL}
#...
end
```

Where `YOUR_APP_KEY` and `YOUR_APP_SECRET` are __Application Id__ and __Application Secret__ retrieved from registering your app in __Login__. `LOGIN_URL` would be the URL for __Login__.
