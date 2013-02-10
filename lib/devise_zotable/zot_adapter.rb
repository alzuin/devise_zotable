require 'net/http'
require 'net/https'
require 'uri'
require 'json'

module Devise

  # simple adapter for Zot credential checking
  # (i don't like to add stuff like this directly to the model)
  module ZotAdapter

    def self.valid_credentials?(username, password, service=nil)
      url = URI.parse("https://#{Devise.zot_server}/#{Devise.zot_login_relative_url}")
      req = Net::HTTP::Post.new(url.path)
      req.use_ssl = true
      req.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req.form_data({:username => username, :password => password, :service => service})
      response = Net::HTTP.new(loginUri.host, loginUri.port).start {|http| http.request(req) }
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
      url = URI.parse("https://#{Devise.zot_server}/#{Devise.zot_token_relative_url}")
      req = Net::HTTP::Post.new(url.path)
      req.use_ssl = true
      req.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req.form_data({:token => token})
      response = Net::HTTP.new(loginUri.host, loginUri.port).start {|http| http.request(req) }
      parsed = JSON.parse(response.body)
      if parsed['status'].to_i == 1
        true
      else
        false
      end
    end

    def self.profile_info(token)
      url = URI.parse("https://#{Devise.zot_server}/#{Devise.zot_token_relative_url}")
      req = Net::HTTP::Post.new(url.path)
      req.use_ssl = true
      req.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req.form_data({:token => token, :profile => true})
      response = Net::HTTP.new(loginUri.host, loginUri.port).start {|http| http.request(req) }
      return JSON.parse(response.body)
    end

    def self.destroy_token(token)
      url = URI.parse("https://#{Devise.zot_server}/#{Devise.zot_logout_relative_url}")
      req = Net::HTTP::Post.new(url.path)
      req.use_ssl = true
      req.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req.form_data({:token => token})
      response = Net::HTTP.new(loginUri.host, loginUri.port).start {|http| http.request(req) }
      parsed = JSON.parse(response.body)
      if parsed['status'].to_i == 1
        true
      else
        false
      end
    end
  end

end
