require 'net/http'
require 'net/https'
require 'uri'
require 'json'

module Devise

  # simple adapter for Zot credential checking
  # (i don't like to add stuff like this directly to the model)
  module ZotAdapter

    def self.valid_credentials?(username, password, service=nil)
      loginUri = URI.parse("https://#{Devise.zot_server}/#{Devise.zot_login_relative_url}")


      response = Net::HTTP.post_form(loginUri, {:username => username, :password => password, :service => service})
      parsed = JSON.parse(response.body)
      if parsed['status'].to_i == 1
        #Net::HTTP.post_form(logoutUri, {:token => parsed['token']})
        # true
        parsed['token']
      else
        false
      end
    end

    def self.valid_token?(token)
      tokenUri = URI.parse("https://#{Devise.zot_server}/#{Devise.zot_token_relative_url}")
      response = Net::HTTP.post_form(tokenUri, {:token => token})
      parsed = JSON.parse(response.body)
      if parsed['status'].to_i == 1
        true
      else
        false
      end
    end

    def self.profile_info(token)
      tokenUri = URI.parse("https://#{Devise.zot_server}/#{Devise.zot_token_relative_url}")
      response = Net::HTTP.post_form(tokenUri, {:token => token, :profile => true })
      return JSON.parse(response.body)
    end

    def self.destroy_token(token)
      logoutUri = URI.parse("https://#{Devise.zot_server}/#{Devise.zot_logout_relative_url}")
      response = Net::HTTP.post_form(logoutUri, {:token => token})
      parsed = JSON.parse(response.body)
      if parsed['status'].to_i == 1
        true
      else
        false
      end
    end
  end

end
