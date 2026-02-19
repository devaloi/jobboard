class JobsController < ApplicationController
  before_action :authenticate_user!, only: %i[apply save_job unsave_job]

  def index
    base_scope = Job.active.includes(:category, :user)
    @q = base_scope.ransack(params[:q])
    @q.sorts = "created_at desc" if @q.sorts.empty?
    @jobs = @q.result(distinct: true)

    @jobs = @jobs.by_type(params[:job_type]) if params[:job_type].present?
    @jobs = @jobs.by_category(params[:category]) if params[:category].present?
    @jobs = @jobs.salary_above(params[:salary_min]) if params[:salary_min].present?

    @jobs = apply_sort(@jobs)
    @pagy, @jobs = pagy(@jobs, limit: 12)
    @categories = Category.ordered
  end

  def show
    @job = Job.includes(:category, :user).find(params[:id])
    @already_applied = user_signed_in? && current_user.seeker? &&
                       @job.job_applications.exists?(user: current_user)
    @already_saved = user_signed_in? && current_user.seeker? &&
                     @job.saved_jobs.exists?(user: current_user)
  end

  def apply
    @job = Job.published.find(params[:id])

    unless current_user.seeker?
      redirect_to job_path(@job), alert: "Only job seekers can apply."
      return
    end

    @application = @job.job_applications.build(
      user: current_user,
      cover_letter: params[:cover_letter],
      status: :applied
    )

    if @application.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to job_path(@job), notice: "Application submitted!" }
      end
    else
      redirect_to job_path(@job), alert: @application.errors.full_messages.join(", ")
    end
  end

  def save_job
    @job = Job.published.find(params[:id])

    unless current_user.seeker?
      redirect_to job_path(@job), alert: "Only job seekers can save jobs."
      return
    end

    current_user.saved_jobs.find_or_create_by(job: @job)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to job_path(@job), notice: "Job saved!" }
    end
  end

  def unsave_job
    @job = Job.find(params[:id])
    current_user.saved_jobs.where(job: @job).destroy_all

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to job_path(@job), notice: "Job removed from saved." }
    end
  end

  private

  def apply_sort(scope)
    case params[:sort]
    when "salary_high"
      scope.order(salary_max: :desc)
    when "salary_low"
      scope.order(salary_min: :asc)
    else
      scope.order(created_at: :desc)
    end
  end
end
