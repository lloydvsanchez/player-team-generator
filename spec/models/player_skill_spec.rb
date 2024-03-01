# frozen_string_literal: true
require 'rails_helper'

RSpec.describe PlayerSkill do
  subject { FactoryBot.create(:player_skill) }

  describe 'validations'  do
    it 'checks for presence of skill' do
      expect(subject.skill).to be_present
    end

    it 'checks for presence of value' do
      expect(subject.value).to be_present
    end

    it 'raises error when skill does not belong to a player' do
      subject.player_id = nil
      subject.valid?
      expect(subject.errors[:player]).to eq ["must exist"]
    end

    it 'raises error when skill attribute is invalid' do
      subject.skill = nil
      subject.valid?
      expect(subject.errors[:skill]).to eq ["is not included in the list"]
    end
  end
end
