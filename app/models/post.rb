class Post < ApplicationRecord

  validates :title, :content, presence: true
  
  def to_s
    title
  end

end
