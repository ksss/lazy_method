require 'lazy_method'
require 'stringio'

module LazyMethodTest
  def test_puts(t)
    io = StringIO.new
    io.puts method
    unless /#<LazyMethod/ =~ io.string
      t.error(io.string)
    end
  end

  def test_call_basic_methods(t)
    ary = []
    [
      [-> { $stdout.method(:puts) }, -> { $stdout.method.puts }],
      [-> { 1.method(:+) }, -> { 1.method.+ }],
      [-> { 1.method(:+@) }, -> { +(1.method) }],
      [-> { ary.method(:[]) }, -> { ary.method[0] }],
      [-> { ary.method(:[]=) }, -> { ary.method.[]=(0, 1) }],
      [-> { ary.method(:to_ary) }, -> { ary.method.to_ary }],
    ].each do |expect_case, test_case|
      unless expect_case.call == test_case.call
        path, line = test_case.source_location
        code = File.open(path) { |f| (line - 1).times { f.gets }; f.gets }
        t.error("LazyMethod methods are should return Method object as much as possible")
        t.log("return #{test_case.call}, expect #{expect_case.call}")
        t.log("#{File.basename(path)}:#{line}: #{code.chomp}")
      end
    end
  end

  def test_name_error(t)
    [
      -> { method.nothing },
      -> { +method },
      -> { method[0] },
    ].each do |test_case|
      begin
        test_case.call
      rescue NameError
      else
        t.error("expect raise error but nothing raised")
      end
    end
  end

  class Foo
    def bar(a, b = nil)
    end
  end

  def test_method_methods(t)
    foo = Foo.new
    LazyMethod::METHOD_METHODS.each do |m|
      s = foo.method.__send__(m)
      unless LazyMethod === s
        t.error("should be LazyMethod instance got #{s}")
      end

      expect = foo.method(:bar).__send__(m)

      next if m == :to_proc

      unless expect == s.bar
        t.error("call #{m} expect #{expect}, got #{s.bar}")
      end
    end
  end
end
