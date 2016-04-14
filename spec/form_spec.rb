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

      a0.form.submit

      a0.wait.time    1
    end
  end

  it "can set many fields using with_xpath" do
    Webdrone.create browser: browser, timeout: 10, error: :raise do |a0|
      a0.open.url     'http://webdrone.io/sandbox/bootstrap'
      
      a0.form.with_xpath do
        set           'Sample Placeholder', 'Sample 01'
        set           'f2', 'Español'
        submit
      end

      a0.form.with_xpath do
        set           'Label for L1', 'OK'
        set           'L2', 'Now'
        submit
      end

      a0.form.with_xpath '//th[contains(., "%s")]/following-sibling::td/input' do
        set           'Field 1', 'uno'
        set           'Field 2', 'two'
        submit
      end
    end
  end
end

describe Webdrone do
  it_behaves_like "form on all browsers", :chrome
  it_behaves_like "form on all browsers", :firefox
  it_behaves_like "form on all browsers", :safari   if OS.mac?
  it_behaves_like "form on all browsers", :ie       if OS.windows?
end
