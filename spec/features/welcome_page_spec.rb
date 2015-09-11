require 'rails_helper'

RSpec.feature "WelcomePage", type: :feature do
  describe "A non logged-in user can shorten a url" do
    it "returns a shortened url when a non logged-in user attempts to shorten url" do
      visit :index
      find(".navbar-form-url").set "www.facebook.com/testing"
      find(".navbar-form-submit").click

      url = Url.first

      expect(page).to have_css(".alert-success", text: "Shortened url:")
      expect(url.url).to eq "http://www.facebook.com/testing"
    end
  end
end
