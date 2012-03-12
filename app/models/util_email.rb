class UtilEmail < ActiveRecord::Base

  #GEMS USED
  #ACCESSORS
  #ASSOCIATIONS
  belongs_to :user

  #CALLBACKS
  #VALIDATIONS
  validates :email,
    :uniqueness => { :case_sensitive => false }, :presence => true,
    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "email format is invalid" }

  #QUERY SCOPES
  scope :is_confirmed, where("confirmation_date is not null and confirmation_token is null")

  #CUSTOM SCOPES
  #SORTING SCOPES
  #OTHER STUFF

  def domain
    email.split("@")[1]
  end

  def is_confirmed
    (!confirmation_date.blank? and confirmation_token.blank?) ? true : false
  end

  def self.create_or_update(uid, email)
    if UtilEmail.where(:email => email, :user_id => uid).first.blank?
      UtilEmail.create(:email => email, :user_id => uid, :confirmation_date => Time.now)
    end
  end

  def self.emails_of_same_user?(e1, e2)
    u1 = UtilEmail.where(:email => e1).first
    if !e2.blank? and !u1.blank?
      u2 = UtilEmail.where(:email => e2).first
      return false if !u2.blank? and u2.user_id != u1.user_id
    end
    return true
  end

end






# == Schema Information
#
# Table name: util_emails
#
#  id                   :integer         not null, primary key
#  user_id              :integer
#  email                :string(255)
#  confirmation_token   :string(255)
#  confirmation_date    :datetime
#  confirmation_sent_at :datetime
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

