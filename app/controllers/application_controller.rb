# frozen_string_literal: true

# The base controller for all other controllers in the application.
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = %i[first_name last_name age date_of_birth phone_number email password
                     password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  private

  def authenticate_admin!
    token_value = request.headers['Authorization']
    render json: { error: 'Authorization token missing' }, status: :unauthorized and return if token_value.blank?

    token = Token.find_by(value: token_value)
    return unless token.nil? || token.expired_at < Time.current

    render json: { error: 'Invalid or expired token' }, status: :unauthorized and return
  end
end
