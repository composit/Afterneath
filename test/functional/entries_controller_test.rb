require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:entries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_entry
    assert_difference('Entry.count') do
      post :create, :entry => {
        :name => entries(:one).name,
        :position => entries(:one).position,
        :content => entries(:one).content,
        :enterer => entries(:one).enterer,
        :enterer_url => entries(:one).enterer_url
      }
    end

    assert_redirected_to new_photo_path( :entry_id => assigns(:entry).id )
  end

  def test_should_show_entry
    get :show, :id => entries(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => entries(:one).id
    assert_response :success
  end

  def test_should_update_entry
    put :update, :id => entries(:one).id, :entry => { }
    assert_redirected_to entry_path(assigns(:entry))
  end

  def test_should_destroy_entry
    assert_difference('Entry.count', -1) do
      delete :destroy, :id => entries(:one).id
    end

    assert_redirected_to entries_path
  end
end
