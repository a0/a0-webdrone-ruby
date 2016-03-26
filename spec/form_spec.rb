require 'spec_helper'

shared_examples "form on all browsers" do |browser|
  it "can mark/set/get/clic an input element on #{browser}" do
    fff = 'Search'
    ttt = %w(This is a sample text).shuffle.join ' '

    Webdrone.create browser: browser, timeout: 10, error: :raise do |a0|
      a0.open.url     'http://webdrone.io/sandbox/bootstrap'

      a0.form.set     fff, ttt

      r=a0.form.get   fff
      expect(r).to eq(ttt)

      a0.form.mark    fff

      a0.form.clic    fff

      a0.wait.time    1
    end
  end
end

describe Webdrone do
  it_behaves_like "form on all browsers", :chrome
  it_behaves_like "form on all browsers", :firefox
  it_behaves_like "form on all browsers", :safari   if OS.mac?
  it_behaves_like "form on all browsers", :ie       if OS.windows?
end
