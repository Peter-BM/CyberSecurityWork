class TokensController < ApplicationController
  before_action :authorize_request

  def revoke
    jti = request.headers['Authorization'].split(' ').last
    decoded = JWT.decode(jti, SECRET_KEY)[0]

    RevokedToken.create!(jti: decoded['jti'])
    render json: { message: 'Token revoked successfully' }, status: :ok
  rescue JWT::DecodeError
    render json: { errors: 'Invalid token' }, status: :unprocessable_entity
  end
end
