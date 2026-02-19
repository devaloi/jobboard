class Job < ApplicationRecord
  belongs_to :user
  belongs_to :category, counter_cache: true

  has_rich_text :body
  has_many :job_applications, class_name: "JobApplication", dependent: :destroy
  has_many :saved_jobs, dependent: :destroy

  enum :job_type, { full_time: 0, part_time: 1, contract: 2, remote: 3 }
  enum :status, { draft: 0, published: 1, closed: 2, archived: 3 }

  validates :title, presence: true
  validates :location, presence: true
  validate :salary_range_valid

  scope :active, -> { published.where("expires_at IS NULL OR expires_at >= ?", Date.current) }
  scope :by_type, ->(type) { where(job_type: type) if type.present? }
  scope :by_category, ->(slug) { joins(:category).where(categories: { slug: slug }) if slug.present? }
  scope :recent, -> { order(created_at: :desc) }
  scope :salary_above, ->(min) { where("salary_min >= ?", min) if min.present? }

  def self.ransackable_attributes(_auth_object = nil)
    %w[title location salary_min salary_max job_type status created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user category]
  end

  def expired?
    expires_at.present? && expires_at < Date.current
  end

  def company_name
    user&.company_name
  end

  private

  def salary_range_valid
    return if salary_min.blank? || salary_max.blank?

    errors.add(:salary_max, "must be greater than or equal to minimum salary") if salary_max < salary_min
  end
end
