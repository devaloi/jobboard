module Admin
  class JobsController < BaseController
    def index
      @pagy, @jobs = pagy(Job.includes(:category, :user).order(created_at: :desc), limit: 20)
    end

    def show
      @job = Job.includes(:category, :user).find(params[:id])
    end

    def destroy
      @job = Job.find(params[:id])
      @job.destroy
      redirect_to admin_jobs_path, notice: "Job listing removed."
    end
  end
end
