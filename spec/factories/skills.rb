FactoryBot.define do
  factory :player_skill, class: 'PlayerSkill' do
    player { create(:player, position: Player.positions.keys.sample) }
    skill { PlayerSkill.skills.keys.first }
    value { rand(100) }
  end
end
