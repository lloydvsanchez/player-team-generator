class Player < ApplicationRecord
  PLAYER_POSITION = {
    defender: 'Defender',
    midfielder: 'Midfielder',
    forward: 'Forward'
  }
  enum position: PLAYER_POSITION

  has_many :player_skills, dependent: :destroy

  alias_attribute :skills, :player_skills

  validates :skills, length: { minimum: 1 }, unless: :new_record?
  validates :name, presence: true

  accepts_nested_attributes_for :player_skills
end
