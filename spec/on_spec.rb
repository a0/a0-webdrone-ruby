# frozen_string_literal: true

require 'spec_helper'

shared_examples ".on on all browsers" do |browser|
  it "can find/mark/text/vrfy/clic an element by .on on #{browser}" do
    ooo = 'btn'
    ttt = '.btn.btn-primary.btn-lg'

    Webdrone.create browser: browser, timeout: 10, error: :raise do |a0|
      a0.open.url       'http://webdrone.io/sandbox/bootstrap'

      a0.find.on        ooo

      a0.mark.on        ooo

      r = a0.text.on    ooo
      expect(r).to eq(ttt)

      a0.vrfy.on        ooo, eq: ttt

      a0.vrfy.on        ooo, contains: ooo

      a0.clic.on        ooo
    end
  end

  it "can find/mark/text/vrfy/clic multiple elements by .on on #{browser}" do
    ooo = 'btn'
    ttt = ['.btn.btn-primary.btn-lg', '.btn.btn-default.btn-lg', '.btn.btn-success.btn-lg', '.btn.btn-warning.btn-lg', '.btn.btn-danger.btn-lg']

    Webdrone.create browser: browser, timeout: 10, error: :raise do |a0|
      a0.open.url       'http://webdrone.io/sandbox/bootstrap'

      r = a0.find.on    ooo, all: true
      expect(r.size).to be == ttt.size

      r = a0.mark.on    ooo, all: true
      expect(r.size).to be == ttt.size

      r = a0.text.on    ooo, all: true
      expect(r).to eq(ttt)

      r = a0.vrfy.on    ooo, all: true, contains: 'btn-lg'
      expect(r.size).to be == ttt.size

      r = a0.clic.on    ooo, all: true
      expect(r.size).to be == ttt.size
    end
  end
end

describe Webdrone do
  it_behaves_like ".on on all browsers", :chrome
  it_behaves_like ".on on all browsers", :firefox
  it_behaves_like ".on on all browsers", :safari   if OS.mac?
  it_behaves_like ".on on all browsers", :ie       if OS.windows?
end
