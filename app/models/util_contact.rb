class UtilContact < ActiveRecord::Base

  #CONSTANTS
  #GEMS USED

  #ACCESSORS
  #ASSOCIATIONS
  belongs_to :project
  belongs_to :user

  #VALIDATIONS
  validates :identifier, :presence => true
  validates :service, :presence => true

  #QUERY SCOPES
  #CUSTOM SCOPES
  #SORTING SCOPES
  #OTHER STUFF
  def self.get(uid, pid, sid)
    UtilContact.where(:user_id => uid, :project_id => pid, :service => sid).first
  end

  def is_link
    return true if ["CS_Y", "CS_T", "CS_L", "CS_F", "CS_E", "CS_WE"].include? service
  end

  def self.add_phone_if_empty(ph, u)
    if !ph.blank?
      p = u.util_contacts.where(:service => "CS_P").first
      if p.blank?
        UtilContact.create(:user_id => u.id, :service => "CS_P", :identifier => ph)
      elsif p.identifier != ph and u.util_contacts.where(:service => "CS_M").first.blank?
        UtilContact.create(:user_id => u.id, :service => "CS_M", :identifier => ph)
      end
    end
  end

  def self.create_or_update(uid, email)
    u = UtilContact.where( :user_id => uid, :service => "CS_E" ).first
    if u.blank?
      u = UtilContact.create(:user_id => uid, :service => "CS_E", :identifier => email)
    elsif email != u.identifier
      u.update_attributes(:identifier => email)
    end
    return u
  end

  #PRIVATE STUFF

end



# == Schema Information
#
# Table name: util_contacts
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  project_id :integer
#  service    :string(255)
#  identifier :string(255)
#  verified   :boolean
#  created_at :datetime
#  updated_at :datetime
#

