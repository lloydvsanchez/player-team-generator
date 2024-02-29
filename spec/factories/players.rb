FactoryBot.define do
  factory :player do
    name      { Faker::Name.name }
    position  { [''].sample }

    factory :player_with_skills do
      skills { [association(:player_skill)] }
    end
  end
end
