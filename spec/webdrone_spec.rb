require 'spec_helper'

describe Webdrone do
  it 'can create a browser with a block' do
    Webdrone.new do |a0|
      puts 'OK'
    end
  end

  it 'can create a browser' do
    a0 = Webdrone.new
    a0.quit
  end

  it 'has a version number' do
    expect(Webdrone::VERSION).not_to be nil
  end
end
