class Meetup < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  has_many :attendees
  has_many :users, through: :attendees
end
