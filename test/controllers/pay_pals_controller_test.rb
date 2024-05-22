require "test_helper"

class PayPalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pay_pals_index_url
    assert_response :success
  end
end
