require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:photos)
  end

  def test_should_get_new
    get :new, :entry_id => entries(:one).id
    assert_response :success
  end

=begin
  def test_should_create_photo
    assert_difference('Photo.count') do
      post :create, :photo => { }
    end

    assert_redirected_to photo_path(assigns(:photo))
  end
=end

  def test_should_show_photo
    get :show, :id => photos(:one).id
    assert_response :success
  end

=begin
  def test_should_get_edit
    get :edit, :id => photos(:one).id
    assert_response :success
  end

  def test_should_update_photo
    put :update, :id => photos(:one).id, :photo => { }
    assert_redirected_to photo_path(assigns(:photo))
  end
=end

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

  def test_should_destroy_photo
    assert_difference('Photo.count', -1) do
      delete :destroy, :id => photos(:one).id
    end

    assert_redirected_to photos_path
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
