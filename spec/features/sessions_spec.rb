require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  scenario "login page can show the log in form" do
    visit login_path
    expect(current_path).to eq(login_path)
    expect(page).to have_css("#session_email")
    expect(page).to have_css("#session_password")
  end

  scenario "it redirects to user page with valid details logs in" do
    user = User.create(first_name: "Cherry", last_name: "Mango", email: "cherry@mango.com", password: "cherry", password_confirmation: "cherry")
    visit login_path

    fill_in "session_email", with: "cherry@mango.com"
    fill_in "session_password", with: "cherry"
    click_button('Login')
    expect(current_path).to eq user_path(user)
  end
end
