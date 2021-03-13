class MessageThread < ApplicationRecord
  STATUS = %w[open waiting closed]
  OPEN_STATUS = %w[open waiting]

  after_create_commit { broadcast_prepend_to(turbo_channel, target: "open_message_threads") }
  after_update_commit { broadcast_replace_to(turbo_channel) }
  after_destroy_commit { broadcast_remove_to(turbo_channel) }

  belongs_to :customer
  belongs_to :team
  belongs_to :user, optional: true
  has_many :messages, dependent: :destroy

  scope :with_open_status, -> { where(status: OPEN_STATUS) }
  scope :without_open_status, -> { where.not(status: OPEN_STATUS) }
  scope :most_recent, -> { order(updated_at: :desc) }

  validates :status, presence: true, inclusion: { in: STATUS }
  validates :subject, presence: true

  def open?
    status == "open"
  end

  def reply_to_address
    return reply_to if reply_to.present?
    team.default_mailbox
  end

  def turbo_channel
    "team_#{team_id}_threads"
  end
end
