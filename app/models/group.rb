class Group < ActiveRecord::Base
    has_many :products, dependent: :destroy
    validates :name, presence: true, uniqueness: true
    validates :boke, presence: true
    validates :tsukkomi, presence: true
end
