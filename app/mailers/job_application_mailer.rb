class JobApplicationMailer < ApplicationMailer
  def status_changed(job_application)
    @application = job_application
    @job = job_application.job
    @user = job_application.user

    mail(
      to: @user.email,
      subject: "Application Update: #{@job.title} — #{@application.status.humanize}"
    )
  end
end
