require 'webdrone/version'
require 'webdrone/browser'
require 'selenium-webdriver'

module Webdrone
  def self.new(*args)
    a0 = Webdrone::Browser.new *args
  end
end
