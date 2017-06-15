class Like < ActiveRecord::Base
    belongs_to :comment, counter_cache: :good
    belongs_to :user
end
