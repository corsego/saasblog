class Post < ApplicationRecord

  validates :title, :content, presence: true

  scope :free, -> { where(premium: false) }
  
  def to_s
    title
  end

end
