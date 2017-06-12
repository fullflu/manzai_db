class Comment < ActiveRecord::Base
    belongs_to :product
    has_many :likes, dependent: :destroy
    def like_user(user_id)
       likes.find_by(user_id: user_id)
    end
    # validates :daihon, presence: true
    # validates :tsukkomi, presence: true
    # validates :tsukkomi, inclusion:{in: [true, false]}
end
