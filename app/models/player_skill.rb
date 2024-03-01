class PlayerSkill < ApplicationRecord
  PLAYER_SKILL = %w(defense attack speed stamina strength)

  belongs_to :player
  validates :skill, inclusion: { in: PLAYER_SKILL }
  validates :value, presence: true
end
