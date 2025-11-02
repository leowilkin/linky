require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  test "can create a link" do
    link = Link.new(short_name: "test", url: "https://example.com")
    assert link.save
  end

  test "requires short_name" do
    link = Link.new(url: "https://example.com")
    assert_not link.save
  end

  test "requires url" do
    link = Link.new(short_name: "test")
    assert_not link.save
  end

  test "authenticated_only defaults to false" do
    link = Link.new(short_name: "test", url: "https://example.com")
    assert_equal false, link.authenticated_only
  end
end
