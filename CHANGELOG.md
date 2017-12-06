# Changelog

New features are summarized here.



## v.1.7.4 - 2017-12-06
### Added
- new `headless` option when creating a Webdrone, currently works only for Chrome
```ruby
a0 = Webdrone.create browser: :chrome, headless: true
```

### Changed
- Webdrone now is using `Selenium::WebDriver::Chrome::Options` instead of old prefs hash; default options object can be retrieved at `Browser.chrome_options`.
- The old `Browser.chrome_prefs` has been removed.
- You can pass an Options object while creating a new Webdrone:
```ruby
chrome_options = Selenium::Webdrive::Chrome::Options.new
# set options here…
chrome_options.add_argument '--headless'

a0 = Webdrone.create browser: :chrome, chrome_options: chrome_options
```



## v.1.7.2 - 2017-08-13
### Added
- New option to clear the mark outline. Enable with `a0.mark.clear = true` or setting the environment variable `WEBDRONE_MARK_CLEAR` to `true`
- Initial support to scroll element with `scroll: true`. Scrolling is supported in the following verbs: `a0.clic.*`, `a0.find.*`, `a0.form.*`, `a0.html.*`, `a0.mark.*`, `a0.text.*` and `a0.vrfy.*` (Closes: #5)



## v.1.7.0 - 2017-08-13
### Added
- Find children elements of a parent element. For ex, given the following HTML:
```HTML
<div id="objects">
  <a>Create</a>
</div>
<div id="properties">
  <a>Create</a>
</div>
```
```ruby
objs = a0.find.id 'objects'
prps = a0.find.id 'properties'

# click properties link
a0.clic.on      'Create', parent: prps
# click objects link
a0.clic.on      'Create', parent: objs
```
- parent is supported in the following verbs: `a0.clic.*`, `a0.find.*`, `a0.form.*`, `a0.html.*`, `a0.mark.*`, `a0.text.*` and `a0.vrfy.*`



## v.1.6.2 - 2017-04-11
### Changed
- Changed default preferences for chrome, disabling the password save dialog.



## v1.6.0 - 2017-01-15
### Added
- Added `mark:` an `shot:` parameters to `a0.clic`. The following code will mark the element, take a screenshot and then click the element.
```
a0.clic.on 'something', mark: true, shot: true
```
### Changed
- Changed default to true for `quit_at_exit` in `Webdrone.create`.
- Setting default of 30 seconds to timeout parameter in `Webdrone.create`. This means the timeout is an optional parameter, for ex:
```ruby
# Before
a0 = Webdrone.create                # <= ArgumentError: missing keyword: timeout
a0 = Webdrone.create timeout: 10    # setting timeout to 10 seconds

# Now
a0 = Webdrone.create                # default timeout of 30 seconds
a0 = Webdrone.create timeout: 10    # overriding timeout to 10 seconds
```
- Renamed `sleep` to `delay` in `a0.mark`, for example:
```ruby
# Before
export WEBDRONE_MARK_TIMES=1
export WEBDRONE_MARK_SLEEP=0
a0.mark.on          'something'

a0.mark.on          'something', times: 2, sleep: 1

# Now
export WEBDRONE_MARK_TIMES=1
export WEBDRONE_MARK_DELAY=0
a0.mark.on          'something'

a0.mark.on          'something', times: 2, delay: 1
```
### Fixed
- Firefox using geckodriver is not supporting window resizing/positioning :-(. The following error will be ignored in the meantime:
```
Selenium::WebDriver::Error::UnsupportedOperationError: The W3C standard does not currently support setting the Window Position"
```


## v1.5.0 - 2016-08-11
### Added
- Added platform info for Webdrone (ruby) on a0_webdrone_trace.csv file
- Added a0.logg.with_group, that generates a new entry for better error detection in the a0_webdrone_trace.csv file. Sample code:
```ruby
# if login group fails, the script is ended
a0.logg.with_group 'Login', abort_error: true do
  a0.open.url           'http://example.com'
  a0.form.set           'user', 'foo'
  a0.form.set           'pass', 'bar'
  a0.mark.on            'login', shot: true
  a0.clic.on            'login'
end

# if operation1 group fails, continue
a0.logg.with_group 'Operation 1' do
  a0.open.url           'http://example.com/operation'
  a0.mark.on            'operation 1', shot: true
  a0.clic.on            'something'
end

# if operation2 group fails, continue
a0.logg.with_group 'Operation 2' do
  a0.open.url           'http://example.com/operation'
  a0.mark.on            'operation 1', shot: true
  a0.clic.on            'something'
end
```



## v1.4.8 - 2016-08-11
### Added
- More platform info on a0_webdrone_trace.csv file



## v1.4.6 - 2016-08-05
### Added
- Change a0.mark.default_times and a0.mark.default_sleep vía environment variables WEBDRONE_MARK_TIMES and WEBDRONE_MARK_SLEEP.
```ruby
# default is 3 times with 0.05 seconds delay between them
a0.mark.on          'something'

# manual override
a0.mark.on          'something', times: 2, sleep: 1

# environment override
export WEBDRONE_MARK_TIMES=1
export WEBDRONE_MARK_SLEEP=0
a0.mark.on          'something'
```



## v1.4.4 - 2016-06-27
### Added
- New parameter `shot` in `a0.form.mark`, to work the same way as `a0.mark` commands. Before:
```ruby
a0.form.mark        'something'
a0.shot.screen      'something'                 # => screenshot-XXX-something.png
```

Now you can do the same in one line:
```ruby
a0.form.mark        'something', shot: true     # => screenshot-XXX-something.png
```

To change the name of the screenshot, pass a String instead of true:
```ruby
a0.form.mark        'something', shot: 'value'  # => screenshot-XXX-value.png
```



## v1.4.2 - 2016-06-27
### Fixed
- Bug in `remote_selenium`, renamed to `remote_url`.



## v1.4.0 - 2016-06-27
### Added
- This changelog.
- New option `Webdrone.create` `remote_url:` for remote selenium servers. Start a server with `java -jar selenium-server.jar`, grab the URL (something like `http://192.168.0.1:4444/wd/hub`), then in your script you can use:
```ruby
a0 = Webdrone.create timeout: 10, browser: :ie, remote_url: 'http://192.168.0.1:4444/wd/hub'
```

You can override this option by using the environment WEBDRONE\_REMOTE\_URL, as usual.


## v1.3.6 - 2016-06-22
### Fixed
- Bug `ArgumentError: comparison of Array with Array failed` when updating empty data using `a0.form.save`.



## v1.3.4 - 2016-06-22
### Fixed
- Bug in `a0.logg` on Windows, when redirecting output to a file.



## v1.3.2 - 2016-06-22
### Changed
- `a0.console` is now disabled if developer mode is turned off (`developer: false` option).
- Ensure a minimum size for `a0.logg`.



## v1.3.0 - 2016-06-17
### Added
- New logger `a0.logg` will automatically log every Webdrone command to stdout AND in trace file `a0_webdrone_trace.csv`.
- New option `Webdrone.create` `logger:` to disable the logger (by default is `true`).
### Changed
- More realible detection of source code when reporting exceptions.



## v1.2.2 - 2016-06-16
### Fixed
- Bug when saving an empty excel in `a0.form.save`.
- Ensure `a0.form.save` updates the excel even if an error occurs.



## v1.2.0 - 2016-06-15
### Added
- New command `a0.form.save`, it keeps an excel file with all data updated when using `a0.form.set` in the given block of code. For example, if you have the following excel and the following code:

|User|wants_email?|
|----|------------|
|fry |            |


```ruby
a0.form.save filename: 'data.xlsx', sheet: 'name or index', item: 'john', name: 'User' do
  a0.form.set 'wants_email?', 'YES'
  a0.form.set 'alternative_email', 'john@example.com'
end
```

The excel will contain the following updated data:

|User|alternative_email|wants_email?|
|----|-----------------|------------|
|fry |                 |            |
|john|john@example.com |YES         |



## v1.1.4 - 2016-06-10
### Added
- `a0.mark` now can take screenshots. So, instead of this code:
```ruby
a0.mark.on          'something'
a0.shot.screen      'something'                 # => screenshot-XXX-something.png
```

You can do the same in one line:
```ruby
a0.mark.on          'something', shot: true     # => screenshot-XXX-something.png
```

You can set the name of the screenshot:
```ruby
a0.mark.on          'something', shot: 'valid'  # => screenshot-XXX-valid.png
```



## v1.1.2 - 2016-06-10
### Fixed
- Bug on empty cells when saving an excel in `a0.xlsx.save`.



## v1.1.0 - 2016-06-07
### Changed
- `a0.vrfy` was not reporting on errors, like the rest of Webdrone.
- The following environment variables are translated from String to boolean:
  - WEBDRONE\_CREATE\_OUTDIR
  - WEBDRONE\_DEVELOPER
  - WEBDRONE\_QUIT\_AT\_EXIT
  - WEBDRONE\_MAXIMIZE

So setting something like `export WEBDRONE_DEVELOPER=false` will work as expected.

### Fixed
- Bugs in `a0.console` when entering developer console on error.



## v.1.0.8 - 2016-06-06
### Changed
- Deprecating `Webdrone.irb_console` and `Webdrone.pry_console`, both replaced with `a0.console` which is based on Pry.



## v1.0.6 - 2016-06-05
### Added
- When using developer mode (`Webdrone.create` `developer: true`), the browser will be placed in the half left portion of your screen, so you can write/debug your scripts on the right ;-)
- A Pry console is available using `Webdrone.pry_console` in addition to `Webdrone.irb_console`.
- You can override any option passed to `Webdrone.create` by using special environment variables. For example, if your scripts runs firefox with a timeout of 10 seconds:
```ruby
# test-script-01.rb
a0 = Webdrone.create timeout: 10, browser: :firefox
```

You can run the same script with a timeout of 20 seconds and using Internet Explorer *WITHOUT ANY CHANGES TO THE SCRIPT*.

```bash
export WEBDRONE_BROWSER=ie
export WEBDRONE_TIMEOUT=20
ruby test-script-01.rb
````
- New option `Webdrone.create` `use_env:` to enable/disable the override described above (by default the option is `true`).

### Changed
- A Pry console instead of IRB is launched when an error ocurrs in developer mode.



## v1.0.4 - 2016-06-01
### Fixed
- Bug in developer mode, sometimes the console did not worked as expected.



## v1.0.2 - 2016-05-04
### Fixed
- Make sure to restore old xpath when using `a0.form.with_xpath`.



## v1.0.0 - 2016-05-04
### Added
- Developer mode: a console appears when an error occurs. The console has the context of your script, so you can debug them easily.
- New option `Webdrone.create` `developer: true` to enable developer mode described above (by default is `false`).
- Added optional parameters `n:`, `visible:` to all commands in `a0.form`: `set`, `get`, `clic`, `mark` and `submit`.
