Gem::Specification.new do |s|
  s.name = "sinatra-security"
  s.version = "0.2.1"
  s.summary = %{Quite simple sinatra authentication plugin.}
  s.description = %{Currently only supports Ohm and Sequel for the
                    ORM backends. Adds a route, some helpers,
                    and a module you can include into your
                    model.}

  s.date = "2010-10-14"
  s.author = "Cyril David"
  s.email = "cyx@pipetodevnull.com"
  s.homepage = "http://github.com/sinefunc/sinatra-security"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.files = ["lib/sinatra/security/helpers.rb", "lib/sinatra/security/identification.rb", "lib/sinatra/security/login_field.rb", "lib/sinatra/security/password.rb", "lib/sinatra/security/user.rb", "lib/sinatra/security/validations.rb", "lib/sinatra/security.rb", "README.markdown", "LICENSE", "Rakefile", "test/helper.rb", "test/sinatra_security_test.rb", "test/test_different_user_class.rb", "test/test_login_field_flexibility.rb", "test/test_password.rb", "test/test_sinatra_security_helpers.rb", "test/test_validations.rb"]

  s.require_paths = ["lib"]

  s.add_dependency "sinatra"
  s.add_development_dependency "cutest0
  s.add_development_dependency "rack-test"
  s.has_rdoc = false
end