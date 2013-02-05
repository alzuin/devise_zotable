require 'net/imap'

module Devise

  # simple adapter for imap credential checking
  # (i don't like to add stuff like this directly to the model)
  module ZotAdapter

    def self.valid_credentials?(username, password)
      imap = Net::IMAP.new(Devise.zot_server, Devise.zot_options)
      imap.login(username, password)
      true
    rescue Net::IMAP::ResponseError => e
      false
    ensure
      imap.disconnect unless imap.nil?
    end

  end

end
