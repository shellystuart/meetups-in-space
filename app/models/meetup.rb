class Meetup < ActiveRecord::Base
  belongs_to :creator, :class_name => 'User'
  has_many :attendees
  has_many :users, through: :attendees

  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :creator_id, presence: true

end
