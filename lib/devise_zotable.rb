# encoding: utf-8
require 'devise'

require 'devise_zotable/schema'
require 'devise_zotable/zot_adapter'

module Devise
  # imap server address for authentication.
  mattr_accessor :zot_server
  @@zot_server = nil

  # default email suffix
  mattr_accessor :zot_default_email_suffix
  @@zot_default_email_suffix = nil
  
  # zot server to use SSL?
  mattr_accessor :zot_options
  @@zot_options = {}

  mattr_accessor :zot_auth_entity
  @@zot_auth_entity = :email

  mattr_accessor :zot_auth_relative_url
  @@zot_auth_relative_url = "/auth/index.php/api/login"
end

# Add +:zot_authenticatable+ strategy to defaults.
#
Devise.add_module(:zot_authenticatable,
                  :strategy   => true,
                  :controller => :sessions,
                  :route      => :session,
                  :model      => 'devise_zotable/model')
                  # Also possible: :route, :flash
