module Admin
  class DashboardController < BaseController
    def show
      @total_users = User.count
      @total_jobs = Job.count
      @total_applications = JobApplication.count
      @recent_jobs = Job.includes(:category, :user).order(created_at: :desc).limit(10)
      @recent_users = User.order(created_at: :desc).limit(10)
    end
  end
end
