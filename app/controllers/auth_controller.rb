class AuthController < ApplicationController
  require 'jwt'

  SECRET_KEY = Rails.application.credentials.secret_key_base.to_s

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token({ user_id: user.id })  
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def encode_token(payload)
    JWT.encode(payload, SECRET_KEY)
  end
end
