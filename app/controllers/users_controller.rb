class UsersController < ApplicationController
    def show
        @products = Product.includes(:group).where(user_id: current_user.id)
    end
end
