require 'net/http'
require 'net/https'
require 'uri'
require 'json'

module Devise

  # simple adapter for Zot credential checking
  # (i don't like to add stuff like this directly to the model)
  module ZotAdapter

    def self.valid_credentials?(username, password, service=nil)
      url = URI.parse("#{Devise.zot_protocol}://#{Devise.zot_server}/#{Devise.zot_login_relative_url}")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({:username => username, :password => password, :service => service})
      sock = Net::HTTP.new(url.host, url.port)
      if Devise.zot_protocol=='https'
        sock.use_ssl = true
        sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response=sock.start {|http| http.request(req) }
      parsed = JSON.parse(response.body)
      if parsed['status'].to_i == 1
        parsed['token']
      else
        false
      end
    end

    def self.valid_token?(token)
      url = URI.parse("#{Devise.zot_protocol}://#{Devise.zot_server}/#{Devise.zot_token_relative_url}")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({:token => token})
      sock = Net::HTTP.new(url.host, url.port)
      if Devise.zot_protocol=='https'
        sock.use_ssl = true
        sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response=sock.start {|http| http.request(req) }
      parsed = JSON.parse(response.body)
      if parsed['status'].to_i == 1
        true
      else
        false
      end
    end

    def self.profile_info(token)
      url = URI.parse("#{Devise.zot_protocol}://#{Devise.zot_server}/#{Devise.zot_token_relative_url}")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({:token => token, :profile => true})
      sock = Net::HTTP.new(url.host, url.port)
      if Devise.zot_protocol=='https'
        sock.use_ssl = true
        sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response=sock.start {|http| http.request(req) }
      return JSON.parse(response.body)
    end

    def self.destroy_token(token)
      url = URI.parse("#{Devise.zot_protocol}://#{Devise.zot_server}/#{Devise.zot_logout_relative_url}")
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data({:token => token})
      sock = Net::HTTP.new(url.host, url.port)
      if Devise.zot_protocol=='https'
        sock.use_ssl = true
        sock.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      response=sock.start {|http| http.request(req) }
      parsed = JSON.parse(response.body)
      if parsed['status'].to_i == 1
        true
      else
        false
      end
    end
  end

end
