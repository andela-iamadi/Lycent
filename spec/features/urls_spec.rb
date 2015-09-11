require "rails_helper"
RSpec.feature "Urls", type: :feature do

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

  describe "only valid urls are shortened" do
    scenario "user tries to submit a blank url" do
      visit root_path

      find(".navbar-form-url").set ""
      find(".navbar-form-submit").click

      expect(page).to have_css(".alert-danger")
    end

    scenario "user types in various invalid urls" do
      visit root_path
      find(".navbar-form-url").set "www.facebook/testing"
      find(".navbar-form-submit").click

      expect(page).to have_css(".alert-danger", text: "Ummm...seems your url is invalid. Cross-check, then try again.")

      find(".navbar-form-url").set "facebook/testing"
      find(".navbar-form-submit").click

      expect(page).to have_css(".alert-danger", text: "Ummm...seems your url is invalid. Cross-check, then try again.")

      find(".navbar-form-url").set ".com"
      find(".navbar-form-submit").click

      expect(page).to have_css(".alert-danger", text: "Ummm...seems your url is invalid. Cross-check, then try again.")
    end
  end
end
