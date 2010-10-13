desc "Run test suite."
task :test do
  require "cutest"
  require "./test/helper"

  Cutest.run(Dir["./test/*_test.rb"])
end

task :default => :test