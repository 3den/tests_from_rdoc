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
