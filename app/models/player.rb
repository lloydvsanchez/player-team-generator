class Player < ApplicationRecord
  PLAYER_POSITION = %w(defender midfielder forward)

  has_many :player_skills, dependent: :destroy

  alias_attribute :skills, :player_skills

  validates :skills, length: { minimum: 1 }, unless: :new_record?
  validates :name, presence: true
  validates :position, inclusion: { in: PLAYER_POSITION }

  accepts_nested_attributes_for :player_skills

  def first_error_message
    error = errors.first
    "#{error.full_message} #{self[error.attribute]}"
  end
end
