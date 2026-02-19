module Employer
  class JobsController < BaseController
    before_action :set_job, only: %i[edit update destroy]

    def index
      @jobs = current_user.jobs.includes(:category).recent
    end

    def new
      @job = current_user.jobs.build
    end

    def create
      @job = current_user.jobs.build(job_params)

      if @job.save
        redirect_to employer_jobs_path, notice: "Job listing created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @job.update(job_params)
        redirect_to employer_jobs_path, notice: "Job listing updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @job.archived!
      redirect_to employer_jobs_path, notice: "Job listing archived."
    end

    private

    def set_job
      @job = current_user.jobs.find(params[:id])
    end

    def job_params
      params.require(:job).permit(:title, :location, :salary_min, :salary_max,
                                  :job_type, :status, :category_id, :expires_at, :body)
    end
  end
end
