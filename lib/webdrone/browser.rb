# frozen_string_literal: true

require 'English'

module Webdrone
  class Browser
    attr_reader :driver

    class << self
      attr_writer :firefox_profile, :chrome_options

      def firefox_profile
        return @firefox_profile if defined? @firefox_profile

        @firefox_profile = Selenium::WebDriver::Firefox::Profile.new
        @firefox_profile['startup.homepage_welcome_url.additional'] = 'about:blank'
        @firefox_profile['browser.download.folderList'] = 2
        @firefox_profile['browser.download.manager.showWhenStarting'] = false
        @firefox_profile['browser.helperApps.neverAsk.saveToDisk'] = 'images/jpeg, application/pdf, application/octet-stream, application/download'

        @firefox_profile
      end

      def firefox_options
        return @firefox_options if defined? @firefox_options

        @firefox_options = Selenium::WebDriver::Firefox::Options.new

        @firefox_options
      end

      def chrome_options
        return @chrome_options if defined? @chrome_options

        @chrome_options = Selenium::WebDriver::Chrome::Options.new
        @chrome_options.add_preference 'download.prompt_for_download', false
        @chrome_options.add_preference 'credentials_enable_service:', false

        @chrome_options
      end
    end

    def initialize(browser: 'firefox', create_outdir: true, outdir: nil, timeout: 30, developer: false, logger: true, quit_at_exit: true, maximize: true, error: :raise_report, win_x: nil, win_y: nil, win_w: nil, win_h: nil, use_env: true, chrome_options: nil, firefox_options: nil, firefox_profile: nil, remote_url: nil, headless: false)
      env_update(Kernel.binding) if use_env

      if create_outdir || outdir
        outdir ||= File.join('webdrone_output', Time.new.strftime('%Y%m%d_%H%M%S'))
        conf.outdir = outdir
      end
      outdir = File.join(Dir.pwd, outdir) if !outdir.nil? && !Pathname.new(outdir).absolute?

      if remote_url
        @driver = Selenium::WebDriver.for :remote, url: remote_url, desired_capabilities: browser.to_sym
      elsif !outdir.nil? && browser.to_sym == :chrome
        chrome_options ||= Browser.chrome_options
        chrome_options.add_preference 'download.default_directory', outdir
        chrome_options.add_argument '--disable-popup-blocking'
        chrome_options.add_argument '--headless' if headless
        chrome_options.add_argument '--start-maximized' if maximize
        maximize = false

        service = Selenium::WebDriver::Service.chrome(args: { log_path: "/tmp/chromedriver.#{$PID}.log", verbose: true })
        @driver = Selenium::WebDriver.for browser.to_sym, options: chrome_options, service: service
      elsif !outdir.nil? && browser.to_sym == :firefox
        firefox_options ||= Browser.firefox_options
        firefox_profile ||= Browser.firefox_profile

        firefox_options.add_argument '-headless' if headless
        downdir = OS.windows? ? outdir.tr('/', '\\') : outdir
        firefox_profile['browser.download.dir'] = downdir
        firefox_options.profile = firefox_profile
        @driver = Selenium::WebDriver.for browser.to_sym, options: firefox_options
      else
        @driver = Selenium::WebDriver.for browser.to_sym
      end

      if quit_at_exit
        at_exit do
          @driver.quit
        rescue StandardError
          nil
        end
      end

      conf.error = error.to_sym
      conf.developer = developer
      conf.timeout = timeout.to_i if timeout
      conf.logger = logger

      if developer
        win_x = win_y = 0
        win_w = 0.5
        win_h = 1.0
      end

      if win_x || win_y || win_w || win_h
        x, y, w, h = exec.script 'return [window.screenLeft ? window.screenLeft : window.screenX, window.screenTop ? window.screenTop : window.screenY, window.screen.availWidth, window.screen.availHeight];'
        win_x ||= x
        win_y ||= y
        if win_w.is_a? Float
          win_w = (w * win_w).to_i
        else
          win_w ||= w
        end
        if win_h.is_a? Float
          win_h = (h * win_h).to_i
        else
          win_h ||= h
        end
        begin
          @driver.manage.window.position = Selenium::WebDriver::Point.new win_x, win_y
          @driver.manage.window.resize_to(win_w, win_h)
        rescue StandardError => e
          puts "Ignoring error on window position/resize: #{e}"
        end
      elsif maximize
        self.maximize
      end
    end

    def maximize
      @driver.manage.window.maximize
    end

    def quit
      @driver.quit
    end

    def console(binding = nil)
      return unless conf.developer

      binding ||= Kernel.binding.of_caller(1)
      old_error = conf.error
      old_developer = conf.developer
      begin
        conf.error = :raise
        conf.developer = false
        Webdrone.pry_console binding
      ensure
        conf.error = old_error
        conf.developer = old_developer
      end
    end

    protected

    def env_update_bool(binding, var, val_old, val_new)
      if val_new == 'true'
        val_new = true
      elsif val_new == 'false'
        val_new = false
      else
        puts "Webdrone: ignoring value '#{val_new}' for boolean parameter #{var}."
        return
      end
      binding.local_variable_set(var, val_new)
      puts "Webdrone: overriding #{var} from '#{val_old}' to '#{val_new}'."
    end

    def env_update(binding)
      bool_vars = %i[create_outdir developer quit_at_exit maximize headless]
      ENV.keys.select { |env| env.start_with? 'WEBDRONE_' }.each do |env|
        var = env[9..-1].downcase.to_sym
        if binding.local_variable_defined? var
          val_old = binding.local_variable_get(var)
          val_new = ENV[env]
          if bool_vars.include? var
            env_update_bool(binding, var, val_old, val_new)
          else
            binding.local_variable_set(var, val_new)
            puts "Webdrone: overriding #{var} from '#{val_old}' to '#{val_new}'."
          end
        elsif v == :mark_times
          n = ENV[env].to_i
          puts "Webdrone: setting mark times to #{n}"
          mark.default_times = n
        elsif v == :mark_sleep
          n = ENV[env].to_f
          puts "Webdrone: setting mark sleep to #{n}"
          mark.default_sleep = n
        else
          puts "Webdrone: ignoring unknown parameter #{env}."
        end
      end
    end
  end
end
