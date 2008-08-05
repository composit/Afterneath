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
      post :create, :entry => { }
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

  def test_should_create_photo_and_transliterate_filename
    photo = fixture_file_upload("/files/IT's, UPPERCASE!  AND, WeIRD.JPG", "image/jpeg")

    # Upload using standard create action
    assert_difference 'Photo.count', 3 do
      post :create, :photo => { :uploaded_data => photo }, :html => { :multipart => true }
    end

    assert_equal "it_s_uppercase_and_weird.jpg", assigns(:photo).filename

    # Test if physical file is actually added (and later deleted)
    filepath = assigns(:photo).public_filename
    assert File.exists?(filepath)

    # Also test the destruction of the file and file data. Included as one test because of the
    # time it takes to run these tests and I don't want to leave files in the temporary directory
    assert_difference 'Photo.count', -3 do
      delete :destroy, :id => assigns(:photo).id
    end

    # Did the file get deleted?
    assert !File.exists?(filepath)
  end

  def test_should_create_photo_using_swfupload_action
    photo = fixture_file_upload("/files/IT's, UPPERCASE!  AND, WeIRD.JPG", "application/octet-stream")

    assert_difference 'Photo.count', 3 do
      post :swfupload, :entry_id => entries(:one).id, :Filedata => photo, :html => { :multipart => true }
    end

    assert_difference 'Photo.count', -3 do
      delete :destroy, :entry_id => entries(:one).id, :id => assigns(:photo).id
    end
  end

end
