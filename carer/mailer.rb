class Mailer
  attr_accessor :messages, :emails, :interval
  def initialize(interval, emails = [])
    @last_sent = nil
    @messages = ""
    @emails = emails
    @interval = interval
  end

  # sends email if time interval has passed
  def notify(message)
    messages << "\n#{message}"
    send_email(messages) if (@last_sent.nil? || Time.now > (@last_sent + interval * 60))
  end

  def send_email(messages)
    # TODO
    # send email
    p "EMAIL SENT to #{emails[0]}"
    @last_sent = Time.now
  end
end
