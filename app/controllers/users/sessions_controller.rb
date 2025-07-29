# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  before_action :check_login_role, only: [:create]

  private

  def check_login_role
    return unless params[:user].present?

    user = User.find_by(email: params[:user][:email].downcase)
    return unless user && user.valid_password?(params[:user][:password]) # Ensure password matches

    # Fallback to params[:role], which should be passed via ?role=staff or ?role=customer
    role_param = params[:role]

    if role_param == 'staff' && !user.staff?
      redirect_to new_user_session_path(role: 'staff'), alert: 'Only staff can log in here.' and return
    elsif role_param == 'customer' && !user.customer?
      redirect_to new_user_session_path(role: 'customer'), alert: 'Only customers can log in here.' and return
    end
  end
end
