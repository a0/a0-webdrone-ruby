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

    def initialize(browser: 'chrome', create_outdir: true, outdir: nil, timeout:, maximize: true, chrome_prefs: nil, firefox_profile: nil)
      if create_outdir or outdir
        outdir ||= File.join("webdrone_output", Time.new.strftime('%Y%m%d_%H%M%S'))
        self.conf.outdir = outdir
      end
      outdir = File.join(Dir.pwd, outdir) if outdir != nil and not Pathname.new(outdir).absolute?
      if outdir != nil and browser.to_sym == :chrome
        chrome_prefs = Browser.chrome_prefs if chrome_prefs == nil
        chrome_prefs[:download][:default_directory] = outdir
        @driver = Selenium::WebDriver.for browser.to_sym, prefs: chrome_prefs, args: ['--disable-popup-blocking']
      elsif outdir != nil and browser.to_sym == :firefox
        firefox_profile = Browser.firefox_profile if firefox_profile == nil
        case RbConfig::CONFIG['host_os'].downcase
          when /mingw|mswin/
            # Windows
            downdir = outdir.gsub("/", "\\")
          else
            downdir = outdir
        end
        firefox_profile['browser.download.dir'] = downdir
        @driver = Selenium::WebDriver.for browser.to_sym, profile: firefox_profile
      else
        @driver = Selenium::WebDriver.for browser.to_sym
      end
      self.conf.timeout = timeout if timeout
      self.maximize if maximize
    end

    def maximize
      @driver.manage.window.maximize
    end

    def quit
      @driver.quit
    end
  end
end
