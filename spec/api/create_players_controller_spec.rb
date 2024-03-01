require 'rails_helper'

describe Api::PlayersController, type: :request do
  describe 'POST /api/players' do
    context 'test_should_post' do
      it "Should return post" do
        post '/api/players', params: { '_json' => 
          {
            "name" => "tst",
            "position" => "defender",
            "player_skills" => [
              {
                "skill" => "defense",
                "value" => 10,    
              }
            ]
          },
        }

        expect(response.status).to be 200
      end

      it "Should return error message" do
        post '/api/players', params: {
          "name" => "tst",
          "position" => "defender1",
          "player_skills" => [
            {
              "skill" => "defense",
              "value" => 10,
            }
          ]
        }
        expect(JSON.parse(response.body)).to eq({"message" => "Invalid value for Position: defender1"})
      end
    end
  end
end
