# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  before_action :check_login_role, only: [:create]

  private

  def check_login_role
    return unless params[:user].present?

    user = User.find_by(email: params[:user][:email].downcase)
    return unless user&.valid_password?(params[:user][:password]) # Ensure password is valid

    role_param = params[:role]

    if role_param.blank?
      flash[:alert] = 'You are not authorized to sign in from this route.'
      redirect_to root_path and return
    end

    if role_param == 'staff' && !user.staff?
      redirect_to new_staff_session_path, alert: 'Only staff can log in here.' and return
    elsif role_param == 'customer' && !user.customer?
      redirect_to new_customer_session_path, alert: 'Only customers can log in here.' and return
    end
  end
end
