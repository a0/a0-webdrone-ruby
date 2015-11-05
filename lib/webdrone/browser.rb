module Webdrone
  class Browser
    attr_accessor :driver

    def initialize(browser: 'chrome', create_outdir: false, outdir: nil)
      if create_outdir or outdir
        outdir ||= "webdrone_output/#{Time.new.strftime('%Y%m%d_%H%M')}"
        self.conf.outdir = outdir
      end
      if outdir != nil and browser.to_sym == :chrome
        prefs = { download: { prompt_for_download: false, default_directory: outdir } }
        @driver = Selenium::WebDriver.for browser.to_sym, prefs: prefs
      elsif outdir != nil and browser.to_sym == :firefox
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['startup.homepage_welcome_url.additional'] = 'about:blank'
        profile['browser.download.dir'] = outdir
        profile['browser.download.folderList'] = 2
        profile['browser.download.manager.showWhenStarting'] = false
        profile['browser.helperApps.neverAsk.saveToDisk'] = "images/jpeg, application/pdf, application/octet-stream"
        @driver = Selenium::WebDriver.for browser.to_sym, profile: profile
      else
        @driver = Selenium::WebDriver.for browser.to_sym
      end
    end

    def quit
      @driver.quit
    end
  end
end
