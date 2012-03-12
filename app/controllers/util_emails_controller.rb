class UtilEmailsController < ApplicationController

  before_filter :authenticate_user!, :allowed?

  def index
    @util_email = UtilEmail.new
    @util_emails = @user.util_emails
  end

  def create
    @util_email = UtilEmail.new(params[:util_email])
    @util_email.confirmation_token = UUID.new.generate
    @util_email.confirmation_date = nil
    @util_email.confirmation_sent_at = Time.now
    if @util_email.save
      flash[:notice] = t('creation.success')
      Emails.confirmation(self).deliver
      @util_email = UtilEmail.new
    else
      flash[:error] = t('creation.failure')
      @target = @util_email
    end
    @util_emails = @user.util_emails
    render 'index'
  end

  def destroy
    @util_email = UtilEmail.find(params[:id])
    @util_email.destroy
    @util_emails = @user.util_emails
    @util_email = UtilEmail.new
    redirect_to :back
  end

  def confirm
    u = UtilEmail.where(:confirmation_token => params[:confirmation_token])
    if !u.nil? and !u.first.nil?
      u.first.update_attributes(:confirmation_token => nil, :confirmation_date => Time.now, :confirmation_sent_at => nil)
      flash[:notice] = "Secondary email ID confirmed."
    else
      flash[:error] = "Secondary email ID could not be confirmed."
    end
    redirect_to current_user
  end

  private

  def allowed?
    @user = User.find(params[:user_id])
    unless @user.id == current_user.id
      flash[:error] = t('permission.denied')
      redirect_to root_url
    end
  end

end
