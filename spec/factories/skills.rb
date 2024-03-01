FactoryBot.define do
  factory :player_skill, class: 'PlayerSkill' do
    player { create(:player, position: Player::PLAYER_POSITION.sample) }
    skill { PlayerSkill::PLAYER_SKILL.sample }
    value { rand(100) }
  end
end
