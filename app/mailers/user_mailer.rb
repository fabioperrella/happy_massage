class UserMailer < ActionMailer::Base
  default from: ENV['SMTP_FROM']
  layout 'mailer'

  def notify_massage(massage_id:, event_creator: Schedule::EventCreator.new)
    @mailer_method = :notify_massage

    massage = Massage.find massage_id
    event = event_creator.create_event(massage: massage)

    mail(
      to: massage.user_email,
      subject: i18n(:subject),
      content_type: "text/calendar; method=REQUEST",
      body: event
    )
  end

  private

  def i18n(key)
    I18n.t("mailers.user_mailer.#{@mailer_method}.#{key}")
  end
end