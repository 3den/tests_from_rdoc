require 'rdoc/rdoc'
require 'forwardable'

module TestsFromRDoc
  class File
    def initialize(filename, debug = false)
      @debug = debug
      @rdoc = RDoc::RDoc.new
      @filename = filename
    end

    def modules
      capture_output do
        @rdoc.document([])
        @file_info = @rdoc.parse_file(@filename)
      end
      @file_info.classes_or_modules.map { |mod| Module.new(mod) }
    end

    def capture_output
      return yield if @debug

      stdout, stderr = $stdout, $stderr
      $stdout = StringIO.new
      $stderr = StringIO.new
      yield
      $stdout, $stderr = stdout, stderr
    end
  end

  class Module
    def initialize(mod)
      @mod = mod
    end

    def methods
      @mod.method_list.map { |method| Method.new(method) }
    end
  end

  class Method
    extend Forwardable
    def_delegators :@method, :name, :comment

    def initialize(method)
      @method = method
    end

    def examples
      parts = RDoc::Markup::Parser.parse(comment).parts

      gather_examples = false
      examples = []

      parts.each { |part|
        if RDoc::Markup::Paragraph === part && gather_examples
          gather_examples = false
        end

        if RDoc::Markup::Paragraph === part && part.parts.grep(/^Examples/)
          gather_examples = true
        end

        if RDoc::Markup::Verbatim === part && gather_examples
          examples << part.parts
        end
      }

      if examples.first
        examples.first.map { |example| Example.new(example) }
      else
        []
      end
    end
  end

  class Example
    attr_reader :actual, :expected

    def initialize(example_str)
      @example_str = example_str
      @actual, @expected = example_str.split(' # => ')
    end

    def to_s
      @example_str.strip
    end
  end
end

class MiniTest::Unit::TestCase
  def self.tests_from_rdoc(filename, debug = false)
    mod = TestsFromRDoc::File.new(filename, debug).modules.first
    mod.methods.each do |method|
      define_method "test_#{method.name}" do
        method.examples.each do |example|
          assert_equal instance_eval(example.expected),
            instance_eval(example.actual)
        end
      end
    end
  end
end
