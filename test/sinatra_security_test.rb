require File.expand_path("helper", File.dirname(__FILE__))

class BasicApp < Sinatra::Base
  enable :sessions

  register Sinatra::Security
  
  require_login "/mass"
  
  get "/login" do
    "<h1>Login Page</h1>"
  end

  get "/public" do
    "Hello Public World"
  end

  get "/private" do
    require_login
  end

  post "/private" do
    require_login
  end

  delete "/private" do
    require_login
  end

  put "/private" do
    require_login
  end
  
  get "/mass/private1" do
    "Private 1"
  end

  get "/mass/private2" do
    "Private 2"
  end
  
  require_login "/admin.html"
  get "/admin.html" do
    "Admin"
  end

  get "/css/main.css" do
    require_login

    "body { color: black }"
  end

  get "/images/:image" do
    require_login

    params[:image]
  end

  get "/js/main.js" do
    require_login

    %{alert("hey")}
  end
end

scope do
  def app
    BasicApp.new
  end
  
  setup do
    clear_cookies
  end

  test "accessing a public url doesn't redirect to login" do
    get "/public"
    
    assert "Hello Public World" == last_response.body
  end

  test "accessing a private url" do
    get "/private"
  
    assert_redirected_to "/login"
    assert "/private" == session[:return_to]
  end
  
  test "accessing a private url with query string params" do
    get "/private?query=string&params=true"

    assert_redirected_to "/login"
    assert "/private?query=string&params=true" == session[:return_to] 
  end

  test "accessing a private url with a method other than GET" do
    post "/private"
    assert ! session[:return_to]
    
    put "/private"
    assert ! session[:return_to]

    delete "/private"
    assert ! session[:return_to]
  end

  test "accessing a private url with GET but as (js|css|png) etc" do
    get "/css/main.css"
    assert ! session[:return_to]

    get "/js/main.js"
    assert ! session[:return_to]

    get "/images/test.png"
    assert ! session[:return_to]

    get "/images/test.gif"
    assert ! session[:return_to]

    get "/images/test.jpg"
    assert ! session[:return_to]

    get "/images/test.jpeg"
    assert ! session[:return_to]
  end
  
  test "being redirected and then logging in" do
    get "/private"

    User.authenticated(User.new(1)) do
      post "/login", username: "quentin", password: "test"
      assert_redirected_to "/private"

      assert ["quentin", "test"] == User.params
    end
  end

  test "being redirected to login and failing authenticating" do
    get "/private"
  
    User.authenticated(nil) do
      post "/login", username: "quentin", password: "test"

      assert_redirected_to "/login"
      assert ["quentin", "test"] == User.params
    end
  end

  test "going to /mass/private1 and /mass/private2" do
    get "/mass/private1"
    assert_redirected_to "/login"

    get "/mass/private2"
    assert_redirected_to "/login"
  end

  test "going to /admin.html" do
    get "/admin.html"
    assert_redirected_to "/login"
  end
end
