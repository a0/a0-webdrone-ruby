require 'spec_helper'

shared_examples "css on all browsers" do |browser|
  it "can find/mark/text/vrfy an element by css on #{browser}" do
    ccc = '.btn-primary'
    ttt = '.btn.btn-primary.btn-lg'
    
    Webdrone.create browser: browser, timeout: 10, error: :raise do |a0|
      a0.open.url     'http://webdrone.io/sandbox/bootstrap'

      a0.find.css     ccc

      a0.mark.css     ccc

      r=a0.text.css   ccc
      expect(r).to eq(ttt)

      a0.vrfy.css     ccc, eq: ttt
      
      a0.vrfy.css     ccc, contains: ccc
    end
  end
  
  it "can find/mark/text multiple elements by css on #{browser}" do
    ccc = 'a.btn'
    ttt = ['.btn.btn-primary.btn-lg', '.btn.btn-default.btn-lg', '.btn.btn-success.btn-lg', '.btn.btn-warning.btn-lg', '.btn.btn-danger.btn-lg']
    
    Webdrone.create browser: browser, timeout: 10, error: :raise do |a0|
      a0.open.url     'http://webdrone.io/sandbox/bootstrap'

      r=a0.find.css   ccc, all: true
      expect(r.size).to be == ttt.size

      r=a0.mark.css   ccc, all: true
      expect(r.size).to be == ttt.size

      r=a0.text.css   ccc, all: true
      expect(r).to eq(ttt)
    end
  end
end

describe Webdrone do
  it_behaves_like "css on all browsers", :chrome
  it_behaves_like "css on all browsers", :firefox
  it_behaves_like "css on all browsers", :safari   if OS.mac?
  it_behaves_like "css on all browsers", :ie       if OS.windows?
end
