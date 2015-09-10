# Webdrone

Yet another selenium webdriver wrapper, ruby version.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webdrone'
```

And then execute:

    $ bundle

Install it yourself as:

    $ gem install webdrone

## Usage

Create a browser:

```ruby
require 'webdrone'

a0 = Webdrone.create
a0.open.url         'http://www.google.com/'
a0.quit

# or
Webdrone.create do |a0|
  a0.open.url       'http://www.google.com/'
end
```

Take a screenshot:

```ruby
a0.shot.name        'login'        # saves to screenshot-0001-login.png
a0.shot.name        'home'         # saves to screenshot-0002-home.png
```

Filling a form:

```ruby
a0.form.set         'q', 'A0::WebDrone'
a0.form.submit
end

# or
a0.form.with_xpath '//label[contains(.,"%s")]/following-sibling::*/*[self::input | self::textarea | self::select]' do
  set               'label', 'value'
  xlsx              sheet: 'ejemplo'
end
a0.form.submit
```

Config:

```ruby
a0.conf.timeout   10
```

Context, text and verification:

```ruby
a0.ctxt.create_tab
a0.open.url     'http:://example.com/'
a0.ctxt.with_frame 'iframe_name' do 
  a0.find.on  'Some link or button'
end
puts  a0.text.id('something')

a0.vrfy.id    'another', contains: 'SOME TEXT'
a0.vrfy.id    'another', eq: 'EXACT TEXT'
a0.vrfy.link  'link', attr: 'disabled', eq: 'true'
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a0/webdrone-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

