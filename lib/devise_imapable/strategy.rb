require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    # Strategy for signing in a user based on his email and password using imap.
    class ZotAuthenticatable < Authenticatable
      def authenticate!
        resource = mapping.to.find_for_zot_authentication(authentication_hash)

        if validate(resource){ resource.valid_password?(password) }
          resource.after_zot_authentication
          success!(resource)
        else
          fail(:invalid)
        end
      end
    end
  end
end

Warden::Strategies.add(:zot_authenticatable, Devise::Strategies::ZotAuthenticatable)