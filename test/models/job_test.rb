require "test_helper"

class JobTest < ActiveSupport::TestCase
  test "valid published job" do
    job = Job.new(
      title: "Test Job", location: "NYC", salary_min: 50000, salary_max: 100000,
      job_type: :full_time, status: :published,
      user: users(:employer_one), category: categories(:engineering)
    )
    assert job.valid?
  end

  test "requires title" do
    job = Job.new(location: "NYC", user: users(:employer_one), category: categories(:engineering))
    assert_not job.valid?
    assert_includes job.errors[:title], "can't be blank"
  end

  test "requires location" do
    job = Job.new(title: "Test", user: users(:employer_one), category: categories(:engineering))
    assert_not job.valid?
    assert_includes job.errors[:location], "can't be blank"
  end

  test "salary_max must be >= salary_min" do
    job = Job.new(
      title: "Test", location: "NYC", salary_min: 100000, salary_max: 50000,
      user: users(:employer_one), category: categories(:engineering)
    )
    assert_not job.valid?
    assert_includes job.errors[:salary_max], "must be greater than or equal to minimum salary"
  end

  test "active scope returns published non-expired jobs" do
    active_jobs = Job.active
    active_jobs.each do |job|
      assert job.published?
      assert_not job.expired?
    end
  end

  test "by_type scope filters correctly" do
    Job.create!(title: "FT Job", location: "NYC", job_type: :full_time, status: :published,
                user: users(:employer_one), category: categories(:engineering))
    assert Job.by_type("full_time").all?(&:full_time?)
  end

  test "enum values" do
    assert_equal %w[full_time part_time contract remote], Job.job_types.keys
    assert_equal %w[draft published closed archived], Job.statuses.keys
  end

  test "company_name delegates to user" do
    job = jobs(:published_rails_job)
    assert_equal job.user.company_name, job.company_name
  end

  test "expired? returns true for past dates" do
    job = Job.new(expires_at: 1.day.ago.to_date)
    assert job.expired?
  end

  test "expired? returns false for future dates" do
    job = Job.new(expires_at: 1.day.from_now.to_date)
    assert_not job.expired?
  end
end
