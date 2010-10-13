module Sinatra
  module Security
    VERSION = "0.2.1"

    autoload :Helpers,        "sinatra/security/helpers"
    autoload :User,           "sinatra/security/user"
    autoload :Validations,    "sinatra/security/validations"
    autoload :Password,       "sinatra/security/password"
    autoload :Identification, "sinatra/security/identification"
    autoload :LoginField,     "sinatra/security/login_field"

    def self.registered(m)
      m.helpers Helpers

      m.set :login_success_message, "You have successfully logged in."
      m.set :login_error_message,   "Wrong Email and/or Password combination."
      m.set :login_url,             "/login"
      m.set :login_user_class,      lambda { ::User }
      m.set :ignored_by_return_to,  /(jpe?g|png|gif|css|js)$/

      m.post "/login" do
        if authenticate(params)
          session[:success] = settings.login_success_message
          redirect_to_return_url
        else
          session[:error] = settings.login_error_message
          redirect settings.login_url
        end
      end
    end

    # Allows you to declaratively declare secured locations based on their
    # path prefix.
    #
    # @example
    #
    #   require_login "/admin"
    #
    #   get "/admin/posts" do
    #     # Posts here
    #   end
    #
    #   get "/admin/users" do
    #     # Users here
    #   end
    #
    # @param [#to_s] path_prefix a string to match against the start of
    #                request.fullpath
    # @return [nil]
    def require_login(path_prefix)
      before do
        require_login if request.fullpath.start_with?(path_prefix)
      end
    end
  end

  register Security if defined?(Base)
end