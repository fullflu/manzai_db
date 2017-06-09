class Comment < ActiveRecord::Base
    belongs_to :product
    # validates :daihon, presence: true
    # validates :tsukkomi, presence: true
    # validates :tsukkomi, inclusion:{in: [true, false]}
end
