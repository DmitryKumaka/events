class Event < ApplicationRecord
  has_and_belongs_to_many :users

  validates_presence_of :name, :date

  scope :past, -> { where('date < ?', Date.today) }
  scope :feature, -> { where('date > ?', Date.today) }
end
