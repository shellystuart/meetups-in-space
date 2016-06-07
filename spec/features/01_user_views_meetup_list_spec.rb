require "spec_helper"

feature "User views meetup list" do

  before do
    @user = User.create(
    provider: "github",
    uid: "1",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    @meetup = Meetup.create(
    name: "Moon Landing",
    description: "Meet on the moon",
    location: "The Moon",
    creator: @user
    )

    @meetup2 = Meetup.create(
    name: "International Space Station Powwow",
    description: "Meet at the ISS",
    location: "International Space Station",
    creator: @user
    )
  end

  scenario "redirects to /meetups" do
    visit '/'
    expect(page).to have_current_path('/meetups')
  end

  scenario "meetup names are link" do
    visit '/meetups'
    expect(page).to have_link('Moon Landing')
    expect(page).to have_css("a[href='/meetups/#{@meetup.id}']")
  end

  scenario "views index page" do
    visit '/meetups'
    expect(page).to have_content "Moon Landing"
    expect(page).to have_content "International Space Station Powwow"
  end

  scenario "sees meetups in alphabetical order" do
    visit '/meetups'
    first_meetup_position = page.body.index("International Space Station Powwow")
    second_meetup_position = page.body.index("Moon Landing")
    expect(first_meetup_position).to be < second_meetup_position
  end
end
