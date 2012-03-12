class UtilContactsController < ApplicationController

  before_filter :authenticate_user!, :allowed?

  def index
    @util_contact = UtilContact.new
    @util_contacts = @user.util_contacts
    @contact_decodes = []
    @existing_contact_types = @util_contacts.map(&:service)
    DecodeConstant::CONTACT_SERVICE_DD.each do |c|
      @contact_decodes << c if !@existing_contact_types.include? c.id
    end
  end

  def create
    @util_contact = UtilContact.new(params[:util_contact])
    if @util_contact.save
      flash[:notice] = t('creation.success')
      @util_contact = UtilContact.new
    else
      flash[:error] = t('creation.failure')
    end
    redirect_to :back
  end

  def destroy
    @util_contact = UtilContact.find(params[:id])
    @util_contact.destroy
    redirect_to :back
  end

  private

  def allowed?
    @user = User.find(params[:user_id])
    unless @user.id == current_user.id
      flash[:error] = t('permission.denied')
      redirect_to root_url
    end
    @contactable = @user
  end

end