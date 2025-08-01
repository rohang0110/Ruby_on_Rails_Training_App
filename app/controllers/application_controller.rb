# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  config.eager_load_paths << Rails.root.join('lib')

  protected

  def configure_permitted_parameters
    added_attrs = %i[first_name last_name age date_of_birth phone_number email password
                     password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  # The path used after sign in
  def after_sign_in_path_for(resource)
    '/homepage'
  end
end