class JobApplicationMailerPreview < ActionMailer::Preview
  def status_changed
    application = JobApplication.includes(:job, :user).first || build_preview_application
    JobApplicationMailer.status_changed(application)
  end

  private

  def build_preview_application
    user = User.new(full_name: "Jane Doe", email: "jane@example.com")
    employer = User.new(full_name: "Employer", company_name: "TechCorp")
    category = Category.new(name: "Engineering")
    job = Job.new(title: "Senior Rails Developer", user: employer, category: category)
    JobApplication.new(job: job, user: user, status: :interview)
  end
end
