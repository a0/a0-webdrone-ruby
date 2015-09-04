require 'spec_helper'

describe Webdrone do
  it 'can exec javascript' do
    Webdrone.new do |a0|
      a0.exec.script    'alert("HELLO");'
    end
  end

  it 'can find a link and clic on it' do
    Webdrone.new do |a0|
      a0.open.url     'http://www.microsoft.com/en-us'
      expect(a0.find.link('Download Center')).not_to be nil
      expect(a0.find.link('Download Centers')).to be nil
      a0.clic.link 'Download Center'
      a0.mark.on 'Buy now', all: true
      a0.shot.screen 'download'
    end
  end

  it 'can take a screenshot' do
    Webdrone.new do |a0|
      a0.open.url     'http://www.google.com'
      a0.shot.screen  'home_page'
    end
  end

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
