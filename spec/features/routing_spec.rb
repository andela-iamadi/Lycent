require "rails_helper"

RSpec.feature "User visiting shortened url is redirected to original url", type: :feature do
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

  describe "user visits a shortened url" do
    scenario "user creates a url, then visits it" do

      visit :index
      find(".navbar-form-url").set "www.facebook.com/"
      find(".navbar-form-submit").click

      url = Url.first

      expect(page).to have_css(".alert-success", text: "Shortened url:")
      expect(url.url).to eq "http://www.facebook.com/"

      original_url = url.url

      visit "/#{url.shortened_path}"

      expect(current_url).to eq original_url
    end
  end
end
