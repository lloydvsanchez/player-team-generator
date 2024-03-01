require 'rails_helper'
describe Api::TeamsController, type: :request do
  describe 'POST /api/teams' do
    context 'test_should_select_team' do
      let!(:player_1) { FactoryBot.create(:player, position: 'defender') }
      let!(:player_skill_1_1) { FactoryBot.create(:player_skill, value: 80, skill: 'defense', player: player_1) }
      let(:player2) { FactoryBot.create(:player, position: 'defender') }
      let(:player2_skill) { FactoryBot.create(:player_skill, value: 81, skill: 'defense', player: player2) }

      subject do
        post '/api/team/process', params: { '_json' => [
          {
            "position": "defender",
            "main_skill": "defense",
            "number_of_players": 2
          }
        ]}
      end

      context "Should select team" do
        before do
          player2_skill
          subject
        end

        after do
          expected_result = [
            preformat_to_json(player2),
            preformat_to_json(player_1),
          ]

          expect(JSON.parse(response.body)).to eq(expected_result)
        end

        it "when main_skill is present in players" do
        end

        it "when main_skill does not exist" do
          player2_skill.update(skill: 'defense')
        end
      end

      it "Should raise InsufficientPlayersForPositionError" do
        subject
        expect(JSON.parse(response.body)).to eq({
          "message" => "Insufficient Players For Position: defender"
        })
      end

      def preformat_to_json(resource)
        resource.as_json(
          only: %w[name position],
          include: {
            player_skills: { only: %w[skill value]}
          }
        )
      end
    end
  end
end
