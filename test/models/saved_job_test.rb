require "test_helper"

class SavedJobTest < ActiveSupport::TestCase
  test "valid saved job" do
    saved = SavedJob.new(user: users(:seeker_two), job: jobs(:published_rails_job))
    assert saved.valid?
  end

  test "uniqueness per user per job" do
    existing = saved_jobs(:saved_by_seeker)
    duplicate = SavedJob.new(user: existing.user, job: existing.job)
    assert_not duplicate.valid?
  end
end
