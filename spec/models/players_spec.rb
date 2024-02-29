# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Player do
  subject { FactoryBot.create(:player, position: Player.positions.keys.sample) }
  let(:model_with_skill) { FactoryBot.create(:player_with_skills)}

  describe 'validations'  do
    it 'checks for presence of name' do
      expect(subject.name).to be_present
    end

    it 'checks for presence of position' do
      expect(subject.position).to be_present
    end

    it 'checks for at least one skill' do
      expect(model_with_skill.valid?).to be true
    end

    it 'raises error when player has no skills' do
      subject.valid?
      expect(subject.errors['skills']).to include 'is too short (minimum is 1 character)'
    end
  end
end
