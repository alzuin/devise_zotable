require 'net/http'
require 'uri'
require 'json'

module Devise

  # simple adapter for Zot credential checking
  # (i don't like to add stuff like this directly to the model)
  module ZotAdapter

    def self.valid_credentials?(username, password, service=nil)
      loginUri = URI.parse("http://#{Devise.zot_server}/#{Devise.zot_login_relative_url}")
      logoutUri = URI.parse("http://#{Devise.zot_server}/#{Devise.zot_logout_relative_url}")

      response = Net::HTTP.post_form(loginUri, {:username => username, :password => password, :service => service})
      parsed = JSON.parse(response.body)
      if parsed['status'].to_i == 1
        Net::HTTP.post_form(logoutUri, {:token => parsed['token']})
        # true
        parsed['token']
      else
        false
      end
    end

  end

end
