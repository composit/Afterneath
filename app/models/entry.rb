class Entry < ActiveRecord::Base
  named_scope :approved, :conditions => "approved = 1", :limit => 20

  has_many :photos

  validates_presence_of :name, :enterer
  validates_uri_existence_of :enterer_url, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :allow_blank => true

  attr_accessor :approval_status

  def before_validation
    self.enterer_url = "http://" + enterer_url unless enterer_url.include? "http" unless enterer_url.blank?
  end

  def content_html
    if !embed_url.blank?
      begin
        embed_response = ActiveSupport::JSON.decode(Net::HTTP.get(URI.parse(embed_request_url)))
        html = embed_response["html"] if embed_response["html"]
        html = "<img src='" + embed_response["url"] + "' alt='flickr image' />" if embed_response["url"]
      rescue
        html = ""
      end
    else # no embed content or photos
      html = ""
    end
    html
  end

  def thumbnail_image
    if !embed_url.blank?
      if embed_url.include? "youtube"
        image = "youtube.jpg"
      else
        begin
          embed_response = ActiveSupport::JSON.decode(Net::HTTP.get(URI.parse(embed_request_url)))
          image = embed_response["thumbnail_url"] if embed_response["thumbnail_url"]
          image = embed_response["url"] if embed_response["url"]
        rescue
          image = nil
        end
      end
    else # no embed content or photos
      image = nil
    end
    image
  end

  def embed_request_url
    if embed_url.include? "youtube"
      endpoint_url = "http://oohembed.com/oohembed/"
    elsif embed_url.include? "flickr"
      endpoint_url = "http://www.flickr.com/services/oembed"
    elsif embed_url.include? "vimeo"
      endpoint_url = "http://www.vimeo.com/api/oembed.json"
    end
    endpoint_url += "?url=" + embed_url
    endpoint_url += "&format=json" if endpoint_url.include? "flickr"
    endpoint_url
  end

  def face_slide
    photos.alphabetical.first
  end

  def small_face_file
    if photos.length > 0
      face = photos.alphabetical.first.public_filename(:face)
    elsif !embed_url.blank?
      face = thumbnail_image
    else
      face = nil
    end
    face
  end
end
