require 'rails_helper'

RSpec.feature "Users", type: :feature do
  describe "User can sign in" do
    scenario "User clicks on sign up link on site navbar" do
      visit root_path
      click_link "Login | Sign Up"

      expect(current_path).to eq login_path

      fill_in "user_first_name", with: "Cherry"
      fill_in "user_email", with: "cherry@mango.com"
      fill_in "user_password", with: "cherry"
      fill_in "user_password_confirmation", with: "cherry"
      click_button('Sign up')

      user = User.first
      puts "the user object: #{user.inspect}"
      expect(user.first_name).to eq "Cherry"
      expect(current_path).to eq user_path(user)
      expect(page).to have_content("Cherry logged in")
    end
  end

  describe "User can visit his/her dashboard to see his/her shortened urls" do
    scenario "user clicks dashboard on home page to go to dashboard" do
      user = User.create(first_name: "Cherry", last_name: "Mango", email: "cherry@mango.com", password: "cherry", password_confirmation: "cherry")

      visit login_path

      expect(current_path).to eq login_path

      fill_in "session_email", with: "cherry@mango.com"
      fill_in "session_password", with: "cherry"
      click_button('Login')

      expect(current_path).to eq user_path(user)

      find(".navbar-form-url").set "www.facebook.com/testing"
      find(".navbar-form-submit").click

      expect(page).to have_css(".alert-success", text: "Shortened url:")
      expect(page).to have_css("#urls_table")
      expect(page).to have_content("www.facebook.com/testing")
    end
  end

  describe "Non logged in user have to login to view dashboard" do
    scenario "non logged in user should be redirected to login form on attempt to view dashboard" do
      visit root_path

      expect(page).not_to have_content("My dashboard")

      visit "/users/1"

      expect(current_path).to eq login_path
    end
  end
end
