class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :created_at, ->{order(created_at: :desc)}
  scope :user_id, ->{where user_id: id}
  scope :feed_by_id, ->(ids){where user_id: ids}
  validates :content, presence: true,
    length: {maximum: Settings.model.micropost.content.maximum}
  validates :image,
    content_type:
    {
      in: Settings.model.micropost.content_type.in,
      message:  I18n.t("model.micropost.valid_image")
    },
    size:
    {
      less_than: 5.megabytes,
      message:  I18n.t("model.micropost.less_than")
    }

  # Returns a resized image for display.
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
