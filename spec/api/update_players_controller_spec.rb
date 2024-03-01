require 'rails_helper'

describe Api::PlayersController, type: :request do
  describe 'PUT /api/players' do
    let!(:player) { FactoryBot.create(:player, id: 2, name: "old name") }
    let!(:player_skill_1) { FactoryBot.create(:player_skill, value: 60, skill: 'speed', player: player) }
    let!(:player_skill_2) { FactoryBot.create(:player_skill, value: 80, skill: 'attack', player: player) }
    let(:params) do
      {
        name: 'updated name',
        position: 'midfielder',
        player_skills: [
          {
            "skill": "strength",
            "value": 40
          },
          {
            "skill": "stamina",
            "value": 30
          }
        ]
      }
    end

    context 'test_should_update' do
      it  "Should update" do
        put "/api/players/#{player.id}", params: params
        expect(response.status).to be 200
      end
    end

    context 'failing tests' do
      it  "Should return :not_found" do
        put "/api/players/#{player.id}00", params: params
        expect(response.status).to be 404
      end

      it  "Should return :unprocessable_entity" do
        put "/api/players/#{player.id}", params: params.merge({ position: 'full-back' })
        expect(response.status).to be 422
      end
    end
  end
end
