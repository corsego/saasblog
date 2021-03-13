class Post < ApplicationRecord

  validates :title, :content, presence: true

  scope :free, -> { where(premium: false) }
  scope :premium, -> { where(premium: true) }
  
  def to_s
    title
  end

end
