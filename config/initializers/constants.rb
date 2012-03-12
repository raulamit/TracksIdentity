class DecodeConstant
  CONTACT_SERVICE_DD = RefDecode.where(:is_active => true, :name => "CONTACT_SERVICE").where("display_value != 'Email'") rescue nil
end

INFO_EMAIL = "support@tracksgiving.com"