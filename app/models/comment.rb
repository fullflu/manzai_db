class Comment < ActiveRecord::Base
    belongs_to :product
    has_many :likes, dependent: :destroy
    def like_user(user_id, comment)
       # binding.pry
       likes.find_by(user_id: user_id)
        # like_uid = Like.select(:user_id).where(comment_id: comment.id).pluck(:user_id)
    end
    validates :daihon, presence: true 
    # validates :tsukkomi, presence: true
    # validates :tsukkomi, inclusion:{in: [true, false]}
end
