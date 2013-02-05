require 'net/http'
require 'uri'
require 'json'

module Devise

  # simple adapter for imap credential checking
  # (i don't like to add stuff like this directly to the model)
  module ZotAdapter

    def self.valid_credentials?(username, password, service=nil)
      uri = URI.parse("http://#{Devise.zot_server}/#{Devise.zot_auth_relative_url}")

      response = Net::HTTP.post_form(uri, {:username => username, :password => password, :service => service})
      parsed = JSON.parse(response)
      if parsed['status'].to_i == 1
        true
      else
        false
      end
    end

  end

end
