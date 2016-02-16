# Webdrone

Yet another selenium webdriver wrapper, ruby version.

There is a groovy version available, at https://github.com/a0/a0-webdrone-groovy.

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

a0 = Webdrone.create timeout: 5
a0.open.url         'http://www.google.com/'
a0.quit

# or
Webdrone.create timeout: 5 do |a0|
  a0.open.url       'http://www.google.com/'
end
```

Take a screenshot:

```ruby
a0.shot.screen        'login'        # saves to screenshot-0001-login.png
a0.shot.screen        'home'         # saves to screenshot-0002-home.png
```

Working with forms:

```ruby

Webdrone.create do |a0|
  a0.open.url       'http://www.google.com/'
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

Filling a form from an xlsx spreadsheet:
```ruby
TODO
```



Config:

```ruby
TODO
```

Saving screenshots and downloaded files to a directory:

```ruby
a0 = Webdrone.create create_outdir: true
print a0.conf.outdir            # <= default is webdrone_output_%date%_%time%

a0.open.url     'http://www.google.cl/'
a0.form.set     'q', "Download sample file filetype:xls\n"
a0.shot.screen  'homepage'      # screenshot is saved in output directory
a0.clic.xpath   '//h3'          # xls file is saved in output directory

# or specify directory yourself
a0 = Webdrone.create outdir: '/tmp/evidences'
print a0.conf.outdir            # <= "/tmp/evidences"
```



Creating tabs and switching iframes:

```ruby
a0.ctxt.create_tab
a0.open.url     'http:://example.com/'
a0.ctxt.with_frame 'iframe_name' do 
  a0.find.on  'Some link or button'
end
```

Getting text:

```ruby
puts  a0.text.id        'some_id'
puts  a0.text.xpath     'some_xpath'
```

Verifying text and HTML attributes

```ruby
a0.vrfy.id    'some_id', contains: 'SOME TEXT'
a0.vrfy.xpath 'some_xpath', eq: 'EXACT TEXT'
a0.vrfy.link  'link', attr: 'disabled', eq: 'true'
a0.vrfy.link  'link', attr: 'sample', contains: 'something'
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a0/a0-webdrone-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

