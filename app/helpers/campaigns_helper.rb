module CampaignsHelper

  def header_colored(campaign)
    str = "<span style=\"color: "
    if campaign.status == 'CSS_PL'
      if current_user.b
        str = str + "red;\"> This campaign is UNDER DESIGN. To switch on the campaign, press the button below."
      elsif current_user.c
        str = str + "red;\"> This campaign is UNDER DESIGN."
      end
    elsif campaign.status == "CSS_AC"
      str = str + "green;\"> The Campaign is LIVE since " + campaign.start_date.to_s
    elsif campaign.status == "CSS_EN"
      str = str + "gray;\"> This Campaign has ENDED :: "  + campaign.start_date.to_s + " to "+ campaign.end_date.to_s
    elsif campaign.status == "CSS_CA"
      str = str + "gray;\"> This Campaign was CANCELED."
    end
    return (str + "</span>")
  end

  def foreign_donations_allowed(obj)
    is_allowed = false
    if obj.class == Project
      is_allowed = true if obj.foreign_donations_allowed?
    elsif obj.class == Campaign
      obj.projects.each do |project|
        if project.foreign_donations_allowed?
          is_allowed = true
          break
        end
      end
    end
    return is_allowed ? "Based on list of approved beneficiary projects, foreign donations are allowed." : "Based on list of approved beneficiary projects, foreign donations are not allowed."
  end

end