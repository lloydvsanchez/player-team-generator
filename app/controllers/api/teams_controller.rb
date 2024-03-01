class Api::TeamsController < ApplicationController
  include Response

  def selection_process
    selected_players = {}

    requirement_params.each do |requirement|
      check_requirements(requirement)
      key = "#{requirement['position']}-#{requirement['main_skill']}"

      next if selected_players.keys.include? key
      selected_players[key] = select_players(requirement).to_a
    end

    json_response(selected_players.values.flatten.uniq.collect { |player| preformat_to_json(player) })
  rescue InsufficientPlayersForPositionError => e
    json_response({ message: e.message }, :unprocessable_entity)
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
    players_query.where("position = ? AND ps.skill = ?",
                        requirement['position'],
                        requirement['main_skill'])
                 .limit(requirement['number_of_players'])
  end

  def select_players_by_value(requirement)
    players_query.select("players.*, MAX(ps.value) as max")
                 .where("position = ? AND ps.skill != ?",
                        requirement['position'],
                        requirement['main_skill'])
                 .group(:id)
                 .limit(requirement['number_of_players'])
  end

  def players_query
    Player.includes(:player_skills)
          .joins('INNER JOIN player_skills AS ps ON ps.player_id=players.id')
          .order('ps.value DESC')
  end

  def requirement_params
    params.fetch('_json', params).collect do |param|
      param.permit(:position, :main_skill, :number_of_players).to_h
    end
  end

  def check_requirements(requirement)
    check_sufficient_players_for_position(requirement['position'], requirement['number_of_players'])
  end

  def check_sufficient_players_for_position(position, required_number)
    return if Player.where(position: position).count >= required_number.to_i

    raise InsufficientPlayersForPositionError.new("Insufficient Players For Position: #{position}")
  end
end

class InsufficientPlayersForPositionError < StandardError; end
