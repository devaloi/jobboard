class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { seeker: 0, employer: 1, admin: 2 }

  has_many :jobs, dependent: :destroy
  has_many :job_applications, class_name: "JobApplication", dependent: :destroy
  has_many :saved_jobs, dependent: :destroy

  validates :full_name, presence: true
  validates :company_name, presence: true, if: :employer?
  validates :role, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[company_name full_name email]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
