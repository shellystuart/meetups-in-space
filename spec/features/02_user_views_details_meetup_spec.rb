require "spec_helper"

feature "User views individual meetup page" do

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

  end


  scenario "sees meetup information" do
    visit "/meetups/#{@meetup.id}"
    expect(page).to have_content(@meetup.name)
    expect(page).to have_content(@meetup.description)
    expect(page).to have_content(@meetup.location)
    expect(page).to have_content(@meetup.creator.username)
  end

end
