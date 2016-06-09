require "spec_helper"

feature "User views individual meetup page" do

  before do
    @user = User.create(
    provider: "github",
    uid: "1",
    username: "jarlax1",
    email: "jarlax1@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=40"
    )

    @user2 = User.create(
    provider: "github",
    uid: "2",
    username: "jarlaxx",
    email: "jarlaxx@launchacademy.com",
    avatar_url: "https://avatars0.githubusercontent.com/u/19436164?v=3&s=40"
    )

    @user3 = User.create(
    provider: "github",
    uid: "3",
    username: "notjarlax",
    email: "notjarlaxx@launchacademy.com",
    avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    @meetup = Meetup.create(
    name: "Moon Landing",
    description: "Meet on the moon",
    location: "The Moon",
    creator: @user
    )

    @attendee = Attendee.create(
    user: @user,
    meetup: @meetup
    )

    @attendee2 = Attendee.create(
    user: @user2,
    meetup: @meetup
    )

  end


  scenario "sees meetup information" do
    visit "/meetups/#{@meetup.id}"
    expect(page).to have_content(@user.username)
    expect(page).to have_css("img[src='#{@user.avatar_url}']")
    expect(page).to have_content(@user2.username)
    expect(page).to have_css("img[src='#{@user2.avatar_url}']")
  end

  scenario "current member doesn't see button" do
    visit "/"
    sign_in_as @user2
    visit "/meetups/#{@meetup.id}"
    expect(page).to have_no_button("Join")
  end

  scenario "creator doesn't see button" do
    visit "/"
    sign_in_as @user
    visit "/meetups/#{@meetup.id}"
    expect(page).to have_no_button("Join")
  end

  scenario "signed in user sees button and signs up" do
    visit "/"
    sign_in_as @user3
    visit "/meetups/#{@meetup.id}"
    click_button "Join"
  end

  scenario "not signed in user sees button but gets error message to sign in" do
    visit "/meetups/#{@meetup.id}"
    click_button "Join"
    expect(page).to have_current_path("/meetups/#{@meetup.id}")
    expect(page).to have_content("Please sign in")
  end

end
