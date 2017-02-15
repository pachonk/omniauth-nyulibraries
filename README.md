# OmniAuth NYU Libraries
[![Build Status](https://api.travis-ci.org/NYULibraries/omniauth-nyulibraries.png?branch=master)](https://travis-ci.org/NYULibraries/omniauth-nyulibraries)
[![Dependency Status](https://gemnasium.com/NYULibraries/omniauth-nyulibraries.png)](https://gemnasium.com/NYULibraries/omniauth-nyulibraries)
[![Code Climate](https://codeclimate.com/github/NYULibraries/omniauth-nyulibraries.png)](https://codeclimate.com/github/NYULibraries/omniauth-nyulibraries)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/omniauth-nyulibraries/badge.png?branch=master)](https://coveralls.io/r/NYULibraries/omniauth-nyulibraries)

OmniAuth strategy for the NYU Libraries OAuth2 provider. Before installing in your application, be sure to have installed [OmniAuth](https://github.com/intridea/omniauth) and registered your application with [Login](https://github.com/NYULibraries/login/blob/feature/client_documentation/GETTING_STARTED.md).

__NOTE:__ Your application must be registered with NYU Libraries login service to use this strategy.
Instructions for registering clients are coming soon.

# Installation
## Gemfile
In your Gemfile add:

```ruby
gem 'omniauth-nyulibraries', github: 'NYULibraries/omniauth-nyulibraries'
```

Then run `bundle install`

## Config

Go to the __config > initializers__ directory and locate __omniauth.rb__, where you will have to add the following:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :nyulibraries, YOUR_APP_KEY, YOUR_APP_SECRET
end
```

If you are using [Devise](https://github.com/plataformatec/devise), go to the __config > initializers__ directory and locate __devise.rb__, where you will have to add the following:

```ruby
Devise.setup do |config|
  #...
  #ADD THIS LINE
  config.omniauth :nyulibraries,  YOUR_APP_KEY, YOUR_APP_SECRET
  #...
end
```

Where `YOUR_APP_KEY` and `YOUR_APP_SECRET` are the __Application Id__ and __Application Secret__ you received at registration.

## Configuration

By default, `omniauth-nyulibraries` authenticates from https://login.library.nyu.edu, and uses "/oauth/authorize" as the authorization path. If you want to authenticate from a different instance of Login,
use the `:client_options` option when you add the provider to your app.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :nyulibraries, YOUR_APP_KEY, YOUR_APP_SECRET,
    client_options: {
      site: LOGIN_URL,
      authorize_path: AUTHORIZE_PATH
    }
end
```

And in Devise:

```ruby
Devise.setup do |config|
  #...
  #ADD THIS LINE
  config.omniauth :nyulibraries,  YOUR_APP_KEY, YOUR_APP_SECRET, client_options: {site: LOGIN_URL, authorize_path: AUTHORIZE_PATH}
  #...
end
```

`LOGIN_URL` would be the URL for Login, and `AUTHORIZE_PATH` would be the authorization path you want to use.

# Example Auth Hash

Here is an example hash you can expect out of this strategy by using `request.env['omniauth.auth']`:

```ruby
{"provider"=>:nyulibraries,
 "uid"=>"name",
 "info"=>
  {"name"=>"name",
   "nickname"=>"name",
   "email"=>"email@site.com"},
 "credentials"=>
  {"token"=>"token",
   "expires_at"=>1111111111,
   "expires"=>true},
 "extra"=>
  {"provider"=>:nyulibraries,
   "identities"=>nil},}
```

# Protocols

Currently this strategy uses a development instance of the NYU Libraries login service to authenticate. A protocol will be coming soon for which instances to access for your implementation.

# OAuth2
## Now you're authenticating with power

Congrats! Your application is now connected to the NYU Libraries login service. It’s an OAuth2 provider which means that it follows an [open standard](http://oauth.net/2/) that offers your client applications the ability to authenticate and request resources (e.g. _username_). Users can now authenticate from any one of the myriad login options NYU Libraries login service offers, and your application will be able to properly identify them.

Using `Omniauth`, this strategy give you the resource `omniauth.auth`, which is a hash (as you can see [here](https://github.com/NYULibraries/omniauth-nyulibraries/tree/feature/documentation#example-auth-hash)) that gives you information about the authenticated user. What this means is that users no longer have to be restricted to be registered on your application!
