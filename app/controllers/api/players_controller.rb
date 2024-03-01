class Api::PlayersController < ApplicationController
  before_action :authenticate, only: [:destroy]

  # GET /players
  def index
    resource = Player.select(:id, :name, :position).includes(:player_skills)
    render json: preformat_to_json(resource)
  end

  # POST /players
  def create
    player = Player.new(
      player_params.merge({ player_skills_attributes: skills_params['player_skills'] })
    )

    if player.save
      render json: preformat_to_json(player)
    else
      render json: { message: player.first_error_message }, status: :unprocessable_entity
    end
  end

  # GET /players/:id
  def show
  end

  # PUT /players/:id
  def update
    if player.update(player_params.merge({ player_skills_attributes: skills_params_with_id }))
      render json: preformat_to_json(player)
    else
      render json: { message: player.first_error_message }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Invalid value for id: #{player_params['id']}" }, status: :not_found
  end

  # DELETE /players/:id
  def destroy
    player.destroy
    head :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Invalid value for id: #{player_params['id']}" }, status: :not_found
  end

  private

  def authenticate
    return if request.headers['Authorization'] == token

    head :unauthorized
  end

  def token
    Rails.application.credentials.authorization_header
  end

  def preformat_to_json(resource)
    resource.as_json(
      only: %w[id name position],
      include: {
        player_skills: { only: %w[id skill value]}
      }
    )
  end

  def player
    @player ||= Player.includes(:player_skills).find(player_params['id'])
  end

  def player_params
    params.fetch('_json', params).permit(:id, :name, :position).to_h
  end

  def skills_params
    params.fetch('_json', params).permit(player_skills: [:skill, :value]).to_h
  end

  def skills_params_with_id
    skills_params['player_skills'].map do |hash|
      hash['id'] = player.skills.find_by(skill: hash['skill'])&.id
      hash
    end
  end
end
