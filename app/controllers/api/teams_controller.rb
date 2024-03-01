class Api::TeamsController < ApplicationController
  def selection_process
    selected_players = {}

    requirement_params.each do |requirement|
      check_requirement(requirement)

      position = requirement['position']
      key = "#{position}-#{requirement['main_skill']}"

      next if selected_players.keys.include? key
      selected_players[key] = select_players(requirement).to_a
    end

    render json: selected_players.values.flatten.uniq.collect { |player| preformat_to_json(player) }
  rescue InsufficientPlayersForPositionError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  private

  def select_players(requirement)
    players = select_players_by_position(requirement)
    number_of_players = requirement['number_of_players'].to_i

    if players.count < number_of_players
      requirement['number_of_players'] = number_of_players - players.count
      players += select_players_by_value(requirement)
    end

    players
  end

  def select_players_by_position(requirement)
    Player.includes(:player_skills)
          .joins('INNER JOIN player_skills AS ps ON ps.player_id=players.id')
          .where("position = ? AND ps.skill = ?",
                 requirement['position'],
                 requirement['main_skill'])
          .order('ps.value DESC')
          .limit(requirement['number_of_players'])
  end

  def select_players_by_value(requirement)
    Player.includes(:player_skills)
          .select("players.*, MAX(ps.value) as max")
          .joins('INNER JOIN player_skills AS ps ON ps.player_id=players.id')
          .where("position = ? AND ps.skill != ?",
                 requirement['position'],
                 requirement['main_skill'])
          .order('ps.value DESC')
          .group(:id)
          .limit(requirement['number_of_players'])
  end

  def requirement_params
    params.fetch('_json', params).collect do |param|
      param.permit(:position, :main_skill, :number_of_players).to_h
    end
  end

  def preformat_to_json(resource)
    resource.as_json(
      only: %w[name position],
      include: {
        player_skills: { only: %w[skill value]}
      }
    )
  end

  def check_requirement(requirement)
    check_sufficient_players_for_position(requirement['position'], requirement['number_of_players'])
  end

  def check_sufficient_players_for_position(position, required_number)
    return if Player.where(position: position).count >= required_number.to_i

    raise InsufficientPlayersForPositionError.new("Insufficient Players For Position: #{position}")
  end
end

class InsufficientPlayersForPositionError < StandardError; end
