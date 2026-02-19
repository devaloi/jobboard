module Employer
  class DashboardController < BaseController
    def show
      @total_listings = current_user.jobs.count
      @active_listings = current_user.jobs.active.count
      @total_applicants = JobApplication.joins(:job).where(jobs: { user_id: current_user.id }).count
      @new_applicants = JobApplication.joins(:job)
                                      .where(jobs: { user_id: current_user.id })
                                      .where("job_applications.created_at >= ?", 1.week.ago)
                                      .count
      @recent_applications = JobApplication.joins(:job)
                                           .includes(:user, job: :category)
                                           .where(jobs: { user_id: current_user.id })
                                           .order(created_at: :desc)
                                           .limit(10)
      @jobs = current_user.jobs.includes(:category).recent.limit(5)
    end
  end
end
