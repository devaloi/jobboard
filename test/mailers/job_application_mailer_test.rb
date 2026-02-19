require "test_helper"

class JobApplicationMailerTest < ActionMailer::TestCase
  test "status_changed sends email with correct details" do
    application = job_applications(:reviewed_application)
    mail = JobApplicationMailer.status_changed(application)

    assert_equal "Application Update: #{application.job.title} — Reviewed", mail.subject
    assert_equal [application.user.email], mail.to
    assert_match application.user.full_name, mail.body.encoded
    assert_match application.job.title, mail.body.encoded
  end
end
