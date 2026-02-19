require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "valid category" do
    category = Category.new(name: "Data Science")
    assert category.valid?
    assert_equal "data-science", category.slug
  end

  test "requires name" do
    category = Category.new
    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "slug uniqueness" do
    Category.create!(name: "Unique Cat")
    duplicate = Category.new(name: "Unique Cat")
    assert_not duplicate.valid?
  end

  test "generates slug from name" do
    category = Category.new(name: "Machine Learning")
    category.valid?
    assert_equal "machine-learning", category.slug
  end

  test "ordered scope" do
    categories = Category.ordered
    assert_equal categories.to_a, categories.sort_by(&:name)
  end
end
