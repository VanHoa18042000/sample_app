class Micropost < ApplicationRecord
  UPDATABLE_ATTRS = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.micropost.max_content}
  validates :image, content_type:
  {
    in: Settings.micropost.image_type,
    message: I18n.t("models.micropost.valid_img"),
    size:
    {
      less_than: Settings.micropost.image_size.megabytes,
      message: I18n.t("models.micropost.larger_than")
    }
  }

  scope :recent_post, ->{order(created_at: :desc)}

  def display_image
    image.variant resize_to_limit: Settings.micropost.image_resize
  end
end
