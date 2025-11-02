require 'test_helper'

class SmokeTest < ActionDispatch::IntegrationTest
  test "application boots successfully" do
    assert Rails.application.initialized?
  end

  test "database connection works" do
    assert ActiveRecord::Base.connection.active?
  end

  test "can access login page" do
    get login_path
    assert_response :success
  end

  test "redirects to login when not authenticated" do
    get links_path
    assert_redirected_to login_path
  end
end
