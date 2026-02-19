class JobApplication < ApplicationRecord
  belongs_to :job, counter_cache: :applications_count
  belongs_to :user

  enum :status, { applied: 0, reviewed: 1, interview: 2, offer: 3, rejected: 4 }

  validates :user_id, uniqueness: { scope: :job_id, message: "has already applied to this job" }

  before_save :track_status_change
  after_create_commit :broadcast_new_application
  after_update_commit :broadcast_status_change

  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :recent, -> { order(created_at: :desc) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[status created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[job user]
  end

  private

  def track_status_change
    self.status_changed_at = Time.current if status_changed?
  end

  def broadcast_new_application
    broadcast_prepend_to(
      "employer_#{job.user_id}_applications",
      target: "applications_list",
      partial: "employer/applications/application_row",
      locals: { application: self }
    )
  end

  def broadcast_status_change
    broadcast_replace_to(
      "seeker_#{user_id}_applications",
      target: dom_id(self, :status),
      partial: "shared/status_badge",
      locals: { application: self }
    )
  end
end
