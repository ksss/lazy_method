# LazyMethod

Inspired by https://bugs.ruby-lang.org/issues/12125

## Usage

```ruby
# standard style
foo = Foo.new
foo.bar                          # where is defined this method?
foo.method(:bar).source_location #=> [file.rb, 10]
foo.bar                          # OK remove `method(:` and `).source_location`
```

```ruby
# lazy_method style
foo = Foo.new
foo.bar                        # where is defined this method?
foo.method.source_location.bar #=> [file.rb, 10]
foo.bar                        # OMG remove `.method.source_location` only
```

```ruby
foo = Foo.new

# make Method object
foo.method(:bar)

# make LazyMethod object
foo.method           #=> #<LazyMethod #<Foo:0x00>>

# make Method object from LazyMethod
foo.method.bar       #=> #<Method: Foo#bar>
foo.method.bar.arity #=> 1

# Lazy call Method method
foo.method.arity     #=>
#<LazyMethod #<Foo:0x00>(arity)>
foo.method.arity.bar #=> 1
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lazy_method'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lazy_method

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
