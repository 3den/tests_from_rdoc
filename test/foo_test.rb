require_relative '../lib/foo'
require_relative '../lib/tests_from_rdoc'

class FooTest < MiniTest::Unit::TestCase
  tests_from_rdoc 'lib/foo.rb'
end
