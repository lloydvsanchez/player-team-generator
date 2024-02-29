class PlayerSkill < ApplicationRecord
  PLAYER_SKILL = {
    defense: 'Defense',
    attack: 'Attack',
    speed: 'Speed',
    stamina: 'Stamina',
    strength: 'Strength'
  }
  enum skill: PLAYER_SKILL

  belongs_to :player
  validates :skill, presence: true
  validates :value, presence: true
end
