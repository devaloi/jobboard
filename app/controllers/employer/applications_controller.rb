module Employer
  class ApplicationsController < BaseController
    before_action :set_job, only: :index

    def index
      @applications = @job.job_applications.includes(:user).recent
      @applications = @applications.by_status(params[:status]) if params[:status].present?
    end

    def status
      @application = JobApplication.joins(:job).where(jobs: { user_id: current_user.id }).find(params[:id])

      if @application.update(status: params[:status])
        JobApplicationMailer.status_changed(@application).deliver_later
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to employer_job_applications_path(@application.job), notice: "Application status updated." }
        end
      else
        redirect_to employer_job_applications_path(@application.job), alert: "Failed to update status."
      end
    end

    private

    def set_job
      @job = current_user.jobs.find(params[:job_id])
    end
  end
end
