class StaticPagesController < ApplicationController

  def home
    if user_signed_in?
      @user = current_user
      redirect_to user_path(current_user)
    end
  end

end
