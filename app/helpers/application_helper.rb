module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def fround(f) #float rounding
    (100*f).round/100.0 #Ref: http://www.ruby-forum.com/topic/165475
  end

  def fullurl_for(str)
    return BASE_URL + str
  end

  def smart_date(i)
    return "" if i.blank?
    i.year == Time.now.year ? i.strftime("%d-%b") : i.strftime("%d-%b-%Y")
  end

  def price(ff)
    sprintf("%0.02f", ff)
  end

  # CHARTING

  def donations_chart_series(campaignid, start_time, genres)
    if !campaignid.blank?
      donations_by_day = BpmStep.from_time(start_time).where(:campaign_id => campaignid, :genre => genres).group("bpm_steps.created_at").select("created_at, sum(amount) as amount")
    else
      donations_by_day = BpmStep.from_time(start_time).where(:genre => genres).group("bpm_steps.created_at").select("created_at, sum(amount) as amount")
    end
    (start_time.to_date..Date.today).map do |date|
      donation = donations_by_day.detect { |donation| donation.created_at.to_date == date }
      donation && donation.amount.to_f || 0
    end
  end

  def donations_chart_series_user(uid, start_time, genres)
    if genres == "UG_B"
      donations_by_day = BpmStep.uncanceled.donation.from_time(start_time).where(:business_id => uid).group("bpm_steps.created_at").select("created_at, sum(amount) as amount")
    elsif genres == "UG_C"
      donations_by_day = BpmStep.uncanceled.donation.from_time(start_time).where(:charity_id => uid).group("bpm_steps.created_at").select("created_at, sum(amount) as amount")
    end
    (start_time.to_date..Date.today).map do |date|
      donation = donations_by_day.detect { |donation| donation.created_at.to_date == date }
      donation && donation.amount.to_f || 0
    end
  end

  # IMAGE_HELPERS

  def linkedin_img_link(linkedin_url)
    link_to_sprite "contact_sprites sprite-linkedin", linkedin_url
  end

  def link_to_sprite(img_css_classes, path, options={})
    link_to "<div class='#{img_css_classes}'></div>".html_safe, path, :method => options[:method], :confirm => options[:confirm], 'data-skip-pjax' => options['data-skip-pjax']
  end

  def delete_link_sprite(path, options={})
    link_to "<div class='login_sprites sprite-deletex'></div>".html_safe, path, :method => :delete, :confirm => options[:confirm] || 'Are you sure?', 'data-skip-pjax' => true
  end

  def campaign_status(c)
    case c.status
      when 'CSS_PL' then return "<div class='login_sprites sprite-status_yellow'></div>".html_safe
      when 'CSS_AC' then return "<div class='login_sprites sprite-status_green'></div>".html_safe
      when 'CSS_EN' then return "<div class='login_sprites sprite-status_gray'></div>".html_safe
      when 'CSS_CA' then return "<div class='login_sprites sprite-status_gray'></div>".html_safe
    end
  end

  def util_contact_icon(c)
    case c.service
      when "CS_Y" then return "<div class='contact_sprites sprite-youtube'></div>".html_safe
      when "CS_T" then return "<div class='contact_sprites sprite-twitter'></div>".html_safe
      when "CS_S" then return "<div class='contact_sprites sprite-skype'></div>".html_safe
      when "CS_P" then return "<div class='contact_sprites sprite-phone1'></div>".html_safe
      when "CS_M" then return "<div class='contact_sprites sprite-mobile'></div>".html_safe
      when "CS_L" then return "<div class='contact_sprites sprite-linkedin'></div>".html_safe
      when "CS_F" then return "<div class='contact_sprites sprite-facebook'></div>".html_safe
      when "CS_E" then return "<div class='contact_sprites sprite-email'></div>".html_safe
      when "CS_WE" then return "<div class='contact_sprites sprite-website'></div>".html_safe
    end
  end

  # COLORED_TEXT

  def bill_paid(b)
    (b.is_received) ? "<span style=\"color:green\">Paid</span>" : (b.is_transfered and !b.is_received) ? "<span style=\"color:orange\">Transfered</span>" : "<span style=\"color:red\">Due</span>"
  end

  def bpm_step_status(bpm)
    if bpm.status == "DS_DE"
      return "<code class=\"green\"><strong>DELIVERED</strong></code>"
    elsif bpm.status == "DS_EX"
      return "<code class=\"red\"><strong>EXCEPTION</strong></code>"
    elsif bpm.status == "DS_CA"
      return "<code class=\"gray\"><strong>CANCELED</strong></code>"
    else
      return "<code class=\"orange\"><strong>IN-TRANSIT</strong></code>"
    end
  end

  def util_email_status(e)
    e.is_confirmed ? "<span style=\"color: green;\">(Confirmed.)</span>" : "<span style=\"color: red;\">(Confirmation Email Sent.)</span>"
  end

  def util_file_status(f)
    f.pending_process ? "<span style=\"color: red;\">: Will be processed in next 15 - 30 minutes.</span>" : "<span style=\"color: green;\">(Processed)</span>"
  end

  def chemistry_status(chemistry)
    str = "<span style=\"color: "
    if chemistry.status == 'RS_IN' or chemistry.status == 'RS_P' or chemistry.status == "RS_R"
      str = str + "red;\">"
    elsif chemistry.status == "RS_A"
      str = str + "green;\">"
    elsif chemistry.status == "RS_E"
      str = str + "gray;\">"
    end
    return (str + chemistry.status_decode.to_s + "</span>")
  end

  def bpm_process_action(b)
    case b.action_type
      when 'BAT_U'     then return ""
      when 'BAT_DP'    then return "decreases by #{b.action_number.to_s}%"
      when 'BAT_IP'    then return "increases by #{b.action_number.to_s}%"
      when 'BAT_DF'    then return "decreases by flat #{b.action_number.to_s}"
      when 'BAT_IF'    then return "increases by flat #{b.action_number.to_s}"
    end
  end

  def bpm_step_matched(bpmstep, is_user)
    b = BpmProcess.bill_b_tax.where(:campaign_id => bpmstep.campaign_id, :created_by => bpmstep.business_id).first
    return "" if b.blank?
    st = is_user ? "It was" : "We"
    case b.action_type
      when 'BAT_U'     then return ""
      when 'BAT_DP'    then return st + " deducted the donation by #{b.action_number.to_s}%."
      when 'BAT_IP'    then return st + " matched the donation by #{b.action_number.to_s}%."
      when 'BAT_DF'    then return st + " deducted the donation by #{b.action_number.to_s}."
      when 'BAT_IF'    then return st + " increased the donation by #{b.action_number.to_s}."
    end
  end

  def order_progress_bar_percentage(o)
    if o.status == "OS_IN"
      return 10
    elsif o.status == "OS_CA"
      return 0
    elsif o.bpm_steps.first.blank?
      return 10
    elsif o.bpm_steps.where(:sort_order => 60).first.status == "DS_DP"
      return 100
    elsif o.status == "OS_DO" and o.bpm_steps.billed_business.first.status != "DS_TR"
      return 33
    else
      return 66
    end
  end

end
