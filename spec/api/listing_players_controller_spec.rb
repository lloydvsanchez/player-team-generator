require 'rails_helper'
describe Api::PlayersController, type: :request do
  describe 'GET /api/players' do
    context 'test_should_list' do
      it 'should list' do
        get api_players_path

        expect(response.status).to be 200
      end
    end
  end
end
