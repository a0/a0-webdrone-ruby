module Webdrone
  class Browser
    attr_accessor :driver

    def initialize(browser: 'chrome')
      @driver = Selenium::WebDriver.for browser.to_sym
    end

    def quit
      @driver.quit
    end
  end
end
