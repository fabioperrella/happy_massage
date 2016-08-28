class UserMailer < ActionMailer::Base
  default from: 'info@locaweb.com.br'
  layout 'mailer'

  def notify_massage(massage_id)
    mail(to: "fabio.perrella@gmail.com", subject: 'aaaa')
  end
end