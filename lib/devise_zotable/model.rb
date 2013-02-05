require 'devise_zotable/strategy'

module Devise
  module Models
    # Authenticable Module, responsible for encrypting password and validating
    # authenticity of a user while signing in.
    #
    # Examples:
    #
    #    User.find(1).valid_password?('password123')         # returns true/false
    #
    module ZotAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_accessor :password
      end

      # Verifies whether an incoming_password (ie from sign in) is the user password.
      def valid_password?(incoming_password)
        valid = Devise::ZotAdapter.valid_credentials?(self.send(Devise.zot_auth_entity), incoming_password)
        if valid && new_record? # Create this record if valid.
          self.token=valid
          create
          return true
        else
          return valid
        end
      end

      # Set password to nil
      def clean_up_passwords
        self.password = nil
      end

      def after_zot_authentication
      end

    protected

      module ClassMethods
        def find_for_zot_authentication(conditions)
          unless Devise.zot_default_email_suffix.nil?
            if conditions[:email] && !conditions[:email].include?('@')
              conditions[:email] = "#{conditions[:email]}@#{Devise.zot_default_email_suffix}"
            end
          end
          
          # Find or create
          find_for_authentication(conditions) || new(conditions)
        end
      end
    end
  end
end
