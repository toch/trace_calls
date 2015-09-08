# TraceCalls

Trace the whole chain of method calls.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trace_calls'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trace_calls

## Usage

```
require 'open-uri'
require 'trace_calls'

TraceCalls::on do
  open('http://google.com', proxy: nil)
end

puts TraceCalls::root
```

The result:
```
+-Kernel::open
  +-#<Class:URI>::parse called from Kernel::open at 33
  | \-URI::Parser::parse called from #<Class:URI>::parse at 747
  | | +-URI::Parser::split called from URI::Parser::parse at 211
  | | +-#<Class:URI>::scheme_list called from URI::Parser::parse at 213
  | | +-#<Class:URI>::scheme_list called from URI::Parser::parse at 214
  | | \-URI::HTTP::initialize called from URI::Parser::parse at 660
  | | | \-URI::Generic::initialize called from URI::HTTP::initialize at 84
  | | | | +-URI::Generic::set_scheme called from URI::Generic::initialize at 203
  | | | | +-URI::Generic::set_userinfo called from URI::Generic::initialize at 204
  | | | | | \-URI::Generic::split_userinfo called from URI::Generic::set_userinfo at 525
...
```

If you want full details, i.e. with the filepath and line, you can use

```
puts TraceCalls::root.to_s(detailed: true)
```

## Contributing

1. Fork it ( https://github.com/toch/trace_calls/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
