class UserMailer < ActionMailer::Base
  default from: 'info@locaweb.com.br'
  layout 'mailer'

  def notify_massage(massage_id:, event_creator: Schedule::EventCreator.new)
    @mailer_method = :notify_massage

    massage = Massage.find massage_id
    event = event_creator.create_event(massage: massage)

    attachments['event.ics'] = { mime_type: 'application/ics', content: event.to_ical }

    mail(
      to: massage.user_email,
      subject: i18n(:subject)
    )
  end

  private

  def i18n(key)
    I18n.t("mailers.user_mailer.#{@mailer_method}.#{key}")
  end
end