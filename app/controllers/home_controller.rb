# frozen_string_literal: true

class HomeController < ApplicationController
before_action :authenticate_user!
  def index
    @role = user_signed_in? ? current_user.role_type : nil
  end
end
