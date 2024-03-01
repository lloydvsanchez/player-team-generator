require 'rails_helper'

describe Api::PlayersController, type: :request do
  describe 'DELETE /api/players' do
    context 'test_should_delete' do
      let!(:player_1) { FactoryBot.create(:player) }
      let(:authorization_header) do
        { 'AUTHORIZATION' => Rails.application.credentials.authorization_header }
      end

      it "Should delete" do
        delete "/api/players/#{player_1.id}", params: {}, headers: authorization_header

        expect(response.status).to be 200
      end

      it "Should be unauthorized" do
        delete "/api/players/#{player_1.id}"

        expect(response.status).to be 401
      end

      it "Should be unauthorized" do
        delete "/api/players/100", params: {}, headers: authorization_header

        expect(response.status).to be 404
      end
    end
  end
end
