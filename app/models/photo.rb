class Photo < ActiveRecord::Base

  belongs_to :entry

  has_attachment :content_type => :image,
    :storage => :file_system,
    :max_size => 20.megabytes,
    :resize_to => '800x600>',
    :thumbnails => { :face => '300x200>', :thumb => '100x100>' }

  validates_as_attachment
  # validates_presence_of :entry_id

end
