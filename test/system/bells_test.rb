require "application_system_test_case"

class BellsTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit new_bell_url

    assert_selector "div#main"

    # vueおよびelement-uiが適用されてるか
    assert_selector "section.el-container"

    # 現在募集中の鐘が反映されているか
    assert_selector "div.now-bell"
  end
end
