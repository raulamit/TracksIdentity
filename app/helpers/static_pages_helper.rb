module StaticPagesHelper

  #This code is to enable DEVISE login to work on homepage

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  #DEVISE end

end
