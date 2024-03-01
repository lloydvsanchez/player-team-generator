module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def preformat_to_json(resource, exclude_id = true)
    players_attrs = %w[name position]
    player_skills_attrs = %w[skill value]

    unless exclude_id
      players_attrs << "id"
      player_skills_attrs << "id"
    end

    resource.as_json(
      only: players_attrs,
      include: {
        player_skills: { only: %w[skill value]}
      }
    )
  end

  def token
    Rails.application.credentials.authorization_header
  end
end
