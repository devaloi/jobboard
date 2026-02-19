module Seeker
  class ApplicationsController < BaseController
    def index
      @applications = current_user.job_applications.includes(job: %i[category user]).recent
    end
  end
end
