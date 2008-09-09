require 'test_helper'

class BlurbsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:blurbs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_blurb
    assert_difference('Blurb.count') do
      post :create, :blurb => { }
    end

    assert_redirected_to blurb_path(assigns(:blurb))
  end

  def test_should_show_blurb
    get :show, :id => blurbs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => blurbs(:one).id
    assert_response :success
  end

  def test_should_update_blurb
    put :update, :id => blurbs(:one).id, :blurb => { }
    assert_redirected_to blurb_path(assigns(:blurb))
  end

  def test_should_destroy_blurb
    assert_difference('Blurb.count', -1) do
      delete :destroy, :id => blurbs(:one).id
    end

    assert_redirected_to blurbs_path
  end
end
