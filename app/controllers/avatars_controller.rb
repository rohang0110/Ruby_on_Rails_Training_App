class AvatarsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(avatar_params)
      redirect_to edit_avatar_path, notice: 'Avatar updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.avatar.purge
    redirect_to edit_avatar_path, notice: 'Avatar deleted successfully.'
  end

  private

  def avatar_params
    params.require(:user).permit(:avatar)
  end
end
