require 'webdrone/version'
require 'webdrone/browser'
require 'webdrone/open'
require 'webdrone/shot'
require 'webdrone/find'
require 'webdrone/clic'
require 'webdrone/exec'
require 'webdrone/mark'
require 'selenium-webdriver'
require 'xpath'

module Webdrone
  def self.new(*args)
    a0 = Webdrone::Browser.new *args
    if block_given?
      begin
        yield a0
      ensure
        a0.quit
      end    
    else
      a0
    end
  end
end
