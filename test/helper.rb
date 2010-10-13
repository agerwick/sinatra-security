$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "cutest"
require "rack/test"
require "sinatra/base"
require "sinatra/security"

class Cutest::Scope
  include Rack::Test::Methods

protected
  def assert_redirected_to(path)
    assert 302  == last_response.status
    assert path == last_response.headers["Location"]
  end

  def session
    last_request.env["rack.session"]
  end
end

# Test Fixtures appear here
class User
  attr :id
  attr_accessor :email, :password, :password_confirmation

  # purely used for testing.
  def self.authenticated(user)
    @authenticated = user
    yield
  ensure
    @authenticated = nil
    @params = nil
  end

  def self.params
    @params
  end

  def self.authenticate(user, pass)
    @params = [user, pass]
    @authenticated
  end

  def initialize(id = nil)
    @id = id
  end

  def errors
    @errors ||= []
  end

  def validate
    # placed here so included validate method has a super to call
  end

protected
  def assert(value, error)
    value or errors.push(error) && false
  end

  def assert_present(att, error = [att, :not_present])
    assert(!send(att).to_s.empty?, error)
  end

  def assert_format(att, format, error = [att, :format])
    if assert_present(att, error)
      assert(send(att).to_s.match(format), error)
    end
  end
end