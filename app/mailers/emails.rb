class Emails < ActionMailer::Base

  def confirmation(util_email)
    @util_email = util_email
    @link = BASE_URL + "\/users\/"
    @link = @link + @util_email.user.cached_slug
    @link = @link + "\/util_emails\/confirm?confirmation_token="
    @link = @link + @util_email.confirmation_token
    mail(
      :to => util_email.email,
      :from => "donations@tracksgiving.com",
      :subject => "[TracksGiving]: Please confirm your secondary email.",
      :tag     => 'signup-confirmation'
    )
  end

end


