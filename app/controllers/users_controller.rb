class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]
  before_filter :find_user, :only => [:show, :edit, :update]
  before_filter :allowed?, :except => [:show]

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = t('updation.success')
      redirect_to :back
    else
      flash[:error] = t('updation.failure')
      render :edit
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def allowed?
    unless @user.id == current_user.id
      flash[:error] = t('permission.denied')
      redirect_to root_url
    end
  end
end