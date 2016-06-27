module Webdrone
  class Browser
    @@firefox_profile = @@chrome_prefs = nil
    attr_accessor :driver

    def self.firefox_profile
      if @@firefox_profile == nil
        @@firefox_profile = Selenium::WebDriver::Firefox::Profile.new
        @@firefox_profile['startup.homepage_welcome_url.additional'] = 'about:blank'
        @@firefox_profile['browser.download.folderList'] = 2
        @@firefox_profile['browser.download.manager.showWhenStarting'] = false
        @@firefox_profile['browser.helperApps.neverAsk.saveToDisk'] = "images/jpeg, application/pdf, application/octet-stream, application/download"
      end
      @@firefox_profile
    end

    def self.firefox_profile=(firefox_profile)
      @@firefox_profile = firefox_profile
    end

    def self.chrome_prefs
      if @@chrome_prefs == nil
        @@chrome_prefs = { download: { prompt_for_download: false } }
      end
      @@chrome_prefs
    end

    def env_update(binding)
      bool_vars = [:create_outdir, :developer, :quit_at_exit, :maximize]
      ENV.keys.select { |env| env.start_with? 'WEBDRONE_' }.each do |env|
        v = env[9..-1].downcase.to_sym
        if binding.local_variable_defined? v
          o = binding.local_variable_get(v)
          n = ENV[env]
          if bool_vars.include? v
            if n == "true"
              n = true
            elsif n == "false"
              n = false
            else
              puts "Webdrone: ignoring value '#{n}' for boolean parameter #{v}."
              next
            end
          end
          binding.local_variable_set(v, n)
          puts "Webdrone: overriding #{v} from '#{o}' to '#{n}'."
        else
          puts "Webdrone: ignoring unknown parameter #{env}."
        end
      end
    end

    def initialize(browser: 'firefox', create_outdir: true, outdir: nil, timeout:, developer: false, logger: true, quit_at_exit: false, maximize: true, error: :raise_report, win_x: nil, win_y: nil, win_w: nil, win_h: nil, use_env: true, chrome_prefs: nil, firefox_profile: nil, remote_selenium: nil)
      env_update(Kernel.binding) if use_env
      if create_outdir or outdir
        outdir ||= File.join("webdrone_output", Time.new.strftime('%Y%m%d_%H%M%S'))
        self.conf.outdir = outdir
      end
      outdir = File.join(Dir.pwd, outdir) if outdir != nil and not Pathname.new(outdir).absolute?
      if remote_selenium
        @driver = Selenium::WebDriver.for :remote, url: remote, desired_capabilities: browser.to_sym
      elsif outdir != nil and browser.to_sym == :chrome
        chrome_prefs = Browser.chrome_prefs if chrome_prefs == nil
        chrome_prefs[:download][:default_directory] = outdir
        @driver = Selenium::WebDriver.for browser.to_sym, prefs: chrome_prefs, args: ['--disable-popup-blocking']
      elsif outdir != nil and browser.to_sym == :firefox
        firefox_profile = Browser.firefox_profile if firefox_profile == nil
        downdir = OS.windows? ? outdir.gsub("/", "\\") : outdir
        firefox_profile['browser.download.dir'] = downdir
        @driver = Selenium::WebDriver.for browser.to_sym, profile: firefox_profile
      else
        @driver = Selenium::WebDriver.for browser.to_sym
      end
      if quit_at_exit
        at_exit do
          begin
            @driver.quit
          rescue
          end
        end
      end
      self.conf.error = error.to_sym
      self.conf.developer = developer
      self.conf.timeout = timeout.to_i if timeout
      self.conf.logger = logger
      
      if developer
        win_x = win_y = 0
        win_w = 0.5
        win_h = 1.0
      end
      if win_x or win_y or win_w or win_h
        x, y, w, h = self.exec.script 'return [window.screenLeft ? window.screenLeft : window.screenX, window.screenTop ? window.screenTop : window.screenY, window.screen.availWidth, window.screen.availHeight];'
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
        @driver.manage.window.position= Selenium::WebDriver::Point.new win_x, win_y
        @driver.manage.window.resize_to(win_w, win_h)
      else
        self.maximize if maximize
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
      binding = Kernel.binding.of_caller(1) unless binding
      old_error = self.conf.error
      old_developer = self.conf.developer
      begin
        self.conf.error = :raise
        self.conf.developer = false
        Webdrone.pry_console binding
      ensure
        self.conf.error = old_error
        self.conf.developer = old_developer
      end
    end
  end
end
