require 'spec_helper'

describe Webdrone do
  it 'can create a browser with a block and open google' do
    Webdrone.new do |a0|
      a0.open.url   'http://www.google.com'
    end
  end

  it 'can create a browser and open yahoo' do
    a0 = Webdrone.new
    a0.open.url   'http://www.yahoo.com'
    a0.quit
  end

  it 'has a version number' do
    expect(Webdrone::VERSION).not_to be nil
  end
end
