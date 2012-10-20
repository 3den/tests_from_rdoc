Tests from RDoc
===============

The idea is to extract test cases from method documentation.

# Example

```ruby
# lib/foo.rb
# See http://tomdoc.org/
module Foo
  # Public: Duplicate some text an arbitrary number of times.
  #
  # text  - The String to be duplicated.
  # count - The Integer number of times to duplicate the text.
  #
  # Examples
  #
  #   Foo.multiplex('Tom', 4) # => 'TomTomTomTom'
  #   Foo.multiplex('apple', 2) # => 'appleapple'
  #
  # Returns the duplicated String.
  def self.multiplex(text, count)
    text * count
  end
end
```

And the test:

```ruby
# test/foo_test.rb
require_relative '../lib/foo'

class FooTest < MiniTest::Unit::TestCase
  tests_from_rdoc 'lib/foo.rb'
end
```

This is basically equal to a following test class:

```ruby
class FooTest < MiniTest::Unit::TestCase
  def test_multiplex
    assert_equal 'TomTomTomTom', Foo.multiplex('Tom', 4)
    assert_equal 'appleapple', Foo.multiplex('apple', 2)
  end
end
```

# TODO

* handle TomDoc convention to put an expected result in a new line
* ...
* add rspec support

# License

Copyright 2012 Wojciech Mach, see LICENSE.
