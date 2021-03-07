class ThreadsMailbox < ApplicationMailbox
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
    # TODO: check for multipart and handle HTML/attachments
    if mail.multipart?
      mail.parts[0].decoded
    else
      mail.decoded
    end
  end

  def ensure_team!
    # @team = Team.first

    recipient = mail.recipients.find { |r| matcher.match?(r) }

    Rails.logger.info("Looking for team with hash: #{recipient[matcher, 1]}")

    @team = Team.find_by(mail_hash: recipient[matcher, 1])

    bounce_with(TeamMailer.not_found(mail.from)) if @team.nil?
  end

  def assign_thread
    # Lookup open threads by this email, if existing, return last one, else create new.
    # mail.subject
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
    customer = Customer.where(team: team, email: mail.from).first_or_initialize

    unless customer.persisted?
      customer.name = from_name.presence || "Unknown Sender"
      customer.save!
    end

    customer
  end

  def from_name
    mail.header["From"].value.sub(%r{\<[^>]+\>}, "").strip
  rescue
    ""
  end

  def matcher
    ApplicationMailbox::THREADS_MATCHER
  end
end
