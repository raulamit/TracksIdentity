class RefDecode < ActiveRecord::Base

  #CONSTANTS
  #GEMS USED
  #ACCESSORS
  #ASSOCIATIONS
  #VALIDATIONS
  set_primary_key :constant_value

  #QUERY SCOPES
  scope :distinctonly,  select("DISTINCT(constant_value), *")

  #CUSTOM SCOPES
  def self.all_values_by_decode_name(decode_name)
    RefDecode.find_all_by_name(decode_name).map(&:id)
  end

  #SORTING SCOPES
  default_scope :order => 'sort_order asc'

  #OTHER STUFF
  def to_s
    display_value
  end

  def self.any
    RefDecode.new(:constant_value => "Any", :display_value => "Any", :sort_order => "-1")
  end

  #PRIVATE STUFF

end



# == Schema Information
#
# Table name: ref_decodes
#
#  id             :integer         not null
#  name           :string(255)     not null
#  constant_value :string(255)     not null, primary key
#  display_value  :string(255)     not null
#  sort_order     :integer
#  is_active      :boolean
#  created_at     :datetime
#  updated_at     :datetime
#

