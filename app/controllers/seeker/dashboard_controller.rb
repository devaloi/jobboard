module Seeker
  class DashboardController < BaseController
    def show
      @applications_count = current_user.job_applications.count
      @interviews_count = current_user.job_applications.interview.count
      @offers_count = current_user.job_applications.offer.count
      @saved_count = current_user.saved_jobs.count

      @recent_applications = current_user.job_applications.includes(job: %i[category user]).recent.limit(5)
      @saved_jobs = current_user.saved_jobs.includes(job: %i[category user]).order(created_at: :desc).limit(5)

      applied_category_ids = current_user.job_applications.joins(:job).pluck("jobs.category_id").uniq
      @suggested_jobs = if applied_category_ids.any?
        Job.active.where(category_id: applied_category_ids)
           .where.not(id: current_user.job_applications.select(:job_id))
           .includes(:category, :user).limit(5)
      else
        Job.active.includes(:category, :user).recent.limit(5)
      end
    end
  end
end
