require "test_helper"

class JobApplicationTest < ActiveSupport::TestCase
  test "valid application" do
    app = JobApplication.new(
      job: jobs(:published_design_job), user: users(:seeker_one),
      status: :applied, cover_letter: "I'm interested"
    )
    assert app.valid?
  end

  test "uniqueness per user per job" do
    existing = job_applications(:applied_application)
    duplicate = JobApplication.new(job: existing.job, user: existing.user, status: :applied)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:user_id], "has already applied to this job"
  end

  test "status enum values" do
    assert_equal %w[applied reviewed interview offer rejected], JobApplication.statuses.keys
  end

  test "tracks status_changed_at on status change" do
    app = job_applications(:applied_application)
    app.update!(status: :reviewed)
    assert_not_nil app.status_changed_at
  end

  test "by_status scope" do
    applied = JobApplication.by_status("applied")
    applied.each { |a| assert a.applied? }
  end

  test "recent scope orders by created_at desc" do
    apps = JobApplication.recent.to_a
    apps.each_cons(2) do |a, b|
      assert a.created_at >= b.created_at
    end
  end
end
