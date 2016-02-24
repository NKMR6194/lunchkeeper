require 'test_helper'

class ShopsControllerTest < ActionController::TestCase
  setup do
    @shop = shops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shop" do
    assert_difference('Shop.count') do
      post :create, shop: { address: @shop.address, capability: @shop.capability, city: @shop.city, close_at: @shop.close_at, email: @shop.email, name: @shop.name, open_at: @shop.open_at, password_digest: @shop.password_digest, phone: @shop.phone, position_x: @shop.position_x, position_y: @shop.position_y, pref: @shop.pref, rang: @shop.rang }
    end

    assert_redirected_to shop_path(assigns(:shop))
  end

  test "should show shop" do
    get :show, id: @shop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shop
    assert_response :success
  end

  test "should update shop" do
    patch :update, id: @shop, shop: { address: @shop.address, capability: @shop.capability, city: @shop.city, close_at: @shop.close_at, email: @shop.email, name: @shop.name, open_at: @shop.open_at, password_digest: @shop.password_digest, phone: @shop.phone, position_x: @shop.position_x, position_y: @shop.position_y, pref: @shop.pref, rang: @shop.rang }
    assert_redirected_to shop_path(assigns(:shop))
  end

  test "should destroy shop" do
    assert_difference('Shop.count', -1) do
      delete :destroy, id: @shop
    end

    assert_redirected_to shops_path
  end
end
