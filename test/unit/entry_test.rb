require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  def test_should_save_with_valid_attributes
    entry = entries(:one)
    assert entry.save
  end

  def test_should_not_save_with_empty_attributes
    entry = Entry.new
    assert !entry.valid?
    assert entry.errors.invalid?(:name)
    assert entry.errors.invalid?(:enterer)
  end

  def test_should_not_save_with_invalid_attributes
    entry = entries(:one)
    entry.enterer_url = "abc"
    assert !entry.valid?
    assert entry.errors.invalid?(:enterer_url)
  end

  def test_should_allow_blank_enterer_url
    entry = entries(:two)
    entry.enterer_url = ""
    assert entry.save
  end

  def test_should_append_http_to_beginning_of_enterer_url
    entry = entries(:one)
    assert entry.save
    assert_equal Entry.find( entries(:one).id ).enterer_url, "http://www.google.com"
  end

  def test_should_return_correct_embed_request_url
    assert_equal entries(:one).embed_request_url, "http://www.flickr.com/services/oembed?url=http://www.flickr.com/photos/composit/2525564558/&format=json"
    assert_equal entries(:two).embed_request_url, "http://www.vimeo.com/api/oembed.json?url=http://vimeo.com/1322257"
    assert_equal entries(:three).embed_request_url, "http://oohembed.com/oohembed/?url=http://www.youtube.com/watch?v=hbtvioV6jog"
  end

  def test_should_return_correct_content_html
    assert_equal entries(:one).content_html, "<img src='http://farm3.static.flickr.com/2121/2525564558_31f81c8fcf.jpg' alt='flickr image' />"
    assert_equal entries(:two).content_html[1..6], "object"
    assert_equal entries(:three).content_html, "<embed src='http://www.youtube.com/v/hbtvioV6jog' type='application/x-shockwave-flash' wmode='transparent' width='425' height='355'></embed>"
  end

  def test_should_return_correct_thumbnail
    assert_equal entries(:one).thumbnail_image, "http://farm3.static.flickr.com/2121/2525564558_31f81c8fcf.jpg"
    # assert_equal entries(:two).thumbnail_image, "http://images.vimeo.com/95/97/74/95977495/95977495_160xXXXXXX.jpg"
    assert_equal entries(:three).thumbnail_image, "/images/youtube.jpg"
  end
end
