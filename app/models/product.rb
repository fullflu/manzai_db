class Product < ActiveRecord::Base
    belongs_to :user
    belongs_to :group
    has_many :comments
    validates :title, presence: true
end
