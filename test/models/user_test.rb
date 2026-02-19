require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user with seeker role" do
    user = User.new(email: "test@example.com", password: "password123", full_name: "Test User", role: :seeker)
    assert user.valid?
  end

  test "employer requires company_name" do
    user = User.new(email: "test@example.com", password: "password123", full_name: "Test", role: :employer)
    assert_not user.valid?
    assert_includes user.errors[:company_name], "can't be blank"
  end

  test "employer with company_name is valid" do
    user = User.new(email: "test@example.com", password: "password123", full_name: "Test", role: :employer, company_name: "Corp")
    assert user.valid?
  end

  test "role helper methods work" do
    assert users(:admin).admin?
    assert users(:employer_one).employer?
    assert users(:seeker_one).seeker?
  end

  test "requires full_name" do
    user = User.new(email: "test@example.com", password: "password123", role: :seeker)
    assert_not user.valid?
    assert_includes user.errors[:full_name], "can't be blank"
  end

  test "associations" do
    employer = users(:employer_one)
    assert_respond_to employer, :jobs
    assert_respond_to employer, :job_applications
    assert_respond_to employer, :saved_jobs
  end
end
