class HomeController < ApplicationController
  def index
    @featured_jobs = Job.active.includes(:category, :user).recent.limit(6)
    @categories = Category.where("jobs_count > 0").ordered
  end
end
