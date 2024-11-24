class ApplicationController < ActionController::API
  require 'jwt'
  include Pundit::Authorization

  SECRET_KEY = Rails.application.credentials.secret_key_base.to_s

  def authorize_request
    header = request.headers['Authorization'] 
    token = header.split(' ').last if header
  
    begin
      decoded = JWT.decode(token, SECRET_KEY)[0]
      if decoded['exp'] < Time.now.to_i
        render json: { errors: 'Token has expired' }, status: :unauthorized 
        return      
      end
      @current_user = User.find(decoded['user_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  rescue_from Pundit::NotAuthorizedError do |exception|
    render json: { errors: exception.message }, status: :forbidden
  end
end
