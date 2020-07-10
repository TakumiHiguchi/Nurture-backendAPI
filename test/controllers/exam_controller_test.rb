require 'test_helper'

class ExamControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get exam_index_url
    assert_response :success
  end

  test "should get create" do
    get exam_create_url
    assert_response :success
  end

  test "should get update" do
    get exam_update_url
    assert_response :success
  end

end
