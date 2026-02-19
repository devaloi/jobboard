module Seeker
  class SavedController < BaseController
    def index
      @saved_jobs = current_user.saved_jobs.includes(job: %i[category user]).order(created_at: :desc)
    end
  end
end
