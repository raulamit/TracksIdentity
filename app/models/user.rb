class User < ActiveRecord::Base

  require 'active_support/all'
  require 'digest/md5'

  #CONSTANTS
  #GEMS USED
  has_friendly_id :username, :use_slug => true, :strip_non_ascii => true
  devise  :database_authenticatable, :token_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  #ACCESSORS
  attr_accessible :login, :email, :password, :remember_me, :name, :username, :unconfirmed_email, :reset_password_token, :reset_password_sent_at
  attr_accessor :login

  #ASSOCIATIONS
  has_many :util_emails,  :dependent => :destroy
  has_many :util_contacts, :dependent => :destroy

  #VALIDATIONS
  validates :terms_of_service, :acceptance => true, :on => :create
  validates :username,  :uniqueness => { :case_sensitive => false }, :presence => { :on => :create }
  validates :email, :uniqueness => { :case_sensitive => false }, :presence => true,
      :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "email format is invalid" }
  validates :password,
      :length => { :within => 8..40, :on => :create },
      :presence => { :on => :create },
      :format => { :with => /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,}$/, :message => "password is too weak", :on => :create },
      :confirmation => true
  validate :validate_email_uniqueness

  #CALLBACKS
  after_save :set_defaults

  #QUERY SCOPES
  #CUSTOM SCOPES
  #SORTING SCOPES
  #OTHER STUFF

  def self.get_by_email(email_str)
    return nil if email_str.blank?
    u = UtilEmail.is_confirmed.where(["lower(email) = :value", {:value => email_str.strip.downcase}]).first
    return u.user if !u.blank?
    return nil
  end

  #PRIVATE STUFF

  private

  def set_defaults
    UtilEmail.create_or_update(self.id, self.email)
  end

  def validate_email_uniqueness
    u = id.blank? ? UtilEmail.where(:email => self.email) : UtilEmail.where(:email => self.email).where("user_id != " + id.to_s)
    errors.add(:email, " is already registered. Please contact us at support@tracksgiving.com if you donated using this email id.") if !u.blank?
  end

  # ------------------------------------------- DEVISE CUSTOMIZATIONS -----------------------------
  # DONT TOUCH, DONT OPTIMIZE, DONT DO ANYTHING - ITS CODE THAT DEVISE GAVE

  protected

   def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)
      u = User.get_by_email(login)
      uid = u != nil ? u.id : 0
      where(conditions).where(:id => uid).first
    end

   def self.send_reset_password_instructions(attributes={})
     recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
     recoverable.send_reset_password_instructions if recoverable.persisted?
     recoverable
   end

   def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
     (case_insensitive_keys || []).each { |k| attributes[k].try(:downcase!) }

     attributes = attributes.slice(*required_attributes)
     attributes.delete_if { |key, value| value.blank? }

     if attributes.size == required_attributes.size
       if attributes.has_key?(:login)
          login = attributes.delete(:login)
          record = find_record(login)
       else
         record = where(attributes).first
       end
     end

     unless record
       record = new

       required_attributes.each do |key|
         value = attributes[key]
         record.send("#{key}=", value)
         record.errors.add(key, value.present? ? error : :blank)
       end
     end
     record
   end

   def self.find_record(login)
     u = User.get_by_email(login)
     uid = u != nil ? u.id : 0
     where(:id => uid).first
   end

   # DONT TOUCH, DONT OPTIMIZE, DONT DO ANYTHING - ITS CODE THAT DEVISE GAVE
   # ------------------------------------------- DEVISE CUSTOMIZATIONS ------------------------------

end




# == Schema Information
#
# Table name: users
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  email                   :string(255)     default(""), not null
#  username                :string(255)
#  genre                   :string(255)
#  cached_slug             :string(255)
#  verified                :boolean
#  unconfirmed_email       :string(255)
#  encrypted_password      :string(128)     default(""), not null
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer         default(0)
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  password_salt           :string(255)
#  confirmation_token      :string(255)
#  confirmed_at            :datetime
#  confirmation_sent_at    :datetime
#  authentication_token    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  universal_tracking_code :string(255)
#

