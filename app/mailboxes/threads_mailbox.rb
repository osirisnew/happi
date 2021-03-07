class ThreadsMailbox < ApplicationMailbox
  MATCHER = %r{(.+)@in.happi.team}
  FROM_EMAIL_MATCHER = %r{[^\s<]+\@[^\s>]+}

  attr_reader :message_thread, :team

  before_processing :ensure_team!
  before_processing :assign_thread

  def process
    message_thread.messages.create!(
      sender: customer,
      status: "received",
      content: email_content
    )
  end

  private

  def email_content
    MailBodyParser.new(mail).content
  end

  def ensure_team!
    if recipient = mail.recipients.find { |r| MATCHER.match?(r) }
      Rails.logger.info("Looking for team with hash: #{recipient[MATCHER, 1]}")

      @team = Team.find_by(mail_hash: recipient[MATCHER, 1])
    else
      Rails.logger.info("Looking for team with custom inbound email: #{mail.recipients.to_sentence}")

      @team = CustomEmailAddress.matching_team_for(emails: mail.recipients)
    end

    bounce_with(TeamMailer.not_found(from_email)) if @team.nil?
  end

  def assign_thread
    # Lookup open threads by this email, if existing, return last one, else create new.
    if customer.message_threads.with_open_status.any?
      @message_thread = customer.message_threads.with_open_status.first
    else
      @message_thread = customer.message_threads.create!(team: team, subject: mail.subject, status: "open")
    end
  end

  def customer
    @customer ||= lookup_customer
  end

  def lookup_customer
    customer = Customer.where(team: team, email: from_email).first_or_initialize

    unless customer.persisted?
      customer.name = from_name.presence || "Unknown Sender"
      customer.save!
    end

    customer
  end

  def from_email
    if mail.header["X-Original-From"]
      mail.header["X-Original-From"].value[FROM_EMAIL_MATCHER, 0]
    else
      mail.from
    end
  end

  def from_name
    if mail.header["X-Original-From"]
      mail.header["X-Original-From"].value.sub(%r{\<[^>]+\>}, "").strip
    else
      mail.header["From"].value.sub(%r{\<[^>]+\>}, "").strip
    end
  rescue
    ""
  end
end
