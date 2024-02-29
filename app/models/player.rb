class Player < ApplicationRecord
  PLAYER_POSITION = {
    defender: 'Defender',
    midfielder: 'Midfielder',
    forward: 'Forward'
  }
  enum position: PLAYER_POSITION

  has_many :player_skills
  alias_attribute :skills, :player_skills

  validates :skills, length: { minimum: 1 }, unless: :new_record?
  validates :name, presence: true
  validates :position, presence: true
end
