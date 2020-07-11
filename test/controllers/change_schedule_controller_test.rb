require 'test_helper'

class ChangeScheduleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get change_schedule_index_url
    assert_response :success
  end

  test "should get create" do
    get change_schedule_create_url
    assert_response :success
  end

  test "should get update" do
    get change_schedule_update_url
    assert_response :success
  end

end
