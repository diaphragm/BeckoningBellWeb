require 'test_helper'

class BellsControllerTest < ActionDispatch::IntegrationTest
  test "get new" do
    get new_bell_path
    assert_response :success
  end

  test "get bell" do
    get bell_path(bells(:bell_1))
    assert_response :success
  end

  test "get no bell" do
    get bell_path(:dummy)
    assert_response :missing
  end

  test "create bell" do
    get new_bell_path
    assert_response :success

    post bells_path, params: {bell: {place_id: "1", password: "test pass", note: "test note #{Time.now}"}}
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "#app-show"
  end
end
