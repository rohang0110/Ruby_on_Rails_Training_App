# frozen_string_literal: true

# HomeController handles the logic for the homepage.
class HomeController < ApplicationController
  def index
    @role = user_signed_in? ? current_user.role_type : nil
  end
end
