require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "Trang chủ | Hướng dẫn Ứng dụng mẫu Ruby trên Rails"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Trợ giúp | Hướng dẫn Ứng dụng mẫu Ruby trên Rails"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "Tìm hiểu | Hướng dẫn Ứng dụng mẫu Ruby trên Rails"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Liên hệ | Hướng dẫn Ứng dụng mẫu Ruby trên Rails"
  end
end
