require "spec_helper"

feature "create a new meetup" do

before do
  @user = User.create(
  provider: "github",
  uid: "1",
  username: "jarlax1",
  email: "jarlax1@launchacademy.com",
  avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
  )
end

  scenario "user navigates to new meetup form page" do
    visit "/"
    click_on "Create a new meetup"
    expect(page).to have_current_path('/meetups/new')
  end

  scenario "user signs in and submits form successfully" do
    visit '/'
    sign_in_as @user
    visit '/meetups/new'
    fill_in "Name", with: "Meeting on Mars"
    fill_in "Location", with: "Mars"
    fill_in "Description", with: "The red planet is awesome"
    click_button "Submit"
    expect(page).to have_current_path("/meetups/#{Meetup.last.id}")
    expect(page).to have_content("Meetup created successfully!")
  end

  scenario "user signs in and only submits name and location" do
    visit '/'
    sign_in_as @user
    visit '/meetups/new'
    fill_in "Name", with: "Morning on Mars"
    fill_in "Location", with: "Mars"
    click_button "Submit"
    expect(page).to have_current_path("/meetups/new")
    expect(page).to have_content("Description can't be blank")
  end

  scenario "user signs in and only submits name and description" do
    visit '/'
    sign_in_as @user
    visit '/meetups/new'
    fill_in "Name", with: "Morning on Mars"
    fill_in "Description", with: "The red planet is awesome"
    click_button "Submit"
    expect(page).to have_current_path("/meetups/new")
    expect(page).to have_content("Location can't be blank")
  end

  scenario "user signs in and only submits location and description" do
    visit '/'
    sign_in_as @user
    visit '/meetups/new'
    fill_in "Location", with: "Mars"
    fill_in "Description", with: "The red planet is awesome"
    click_button "Submit"
    expect(page).to have_current_path("/meetups/new")
    expect(page).to have_content("Name can't be blank")
  end

  scenario "user doesn't sign in" do
    visit '/meetups/new'
    fill_in "Name", with: "Morning on Mars"
    fill_in "Location", with: "Mars"
    fill_in "Description", with: "The red planet is awesome"
    click_button "Submit"
    expect(page).to have_current_path("/meetups/new")
    expect(page).to have_content("Creator can't be blank")
  end

  scenario "form is re-rendered with previously submitted details" do
    visit "/meetups/new"
    fill_in "Name", with: "name"
    click_button "Submit"

    expect(page).to have_css("input[value='name']")
  end


end
