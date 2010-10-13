require File.expand_path("helper", File.dirname(__FILE__))

class BasicApp < Sinatra::Base
  class Operator < Struct.new(:id)
    def self.authenticate(u, p)
      return new(1001) if u == "Foo" && p == "Bar"
    end
  end

  enable :sessions

  register Sinatra::Security

  set :login_user_class, lambda { Operator }

  get "/secured" do
    require_login

    "Secured!"
  end
end

# an app with a different user class
scope do
  def app
    BasicApp.new
  end

  setup do
    clear_cookies
  end

  test "blocks non-authenticated users properly" do
    get "/secured"
    assert_redirected_to "/login"
  end

  test "authenticates properly" do
    post "/login", :username => "Foo", :password => "Bar"
    assert_redirected_to "/"
  end
end