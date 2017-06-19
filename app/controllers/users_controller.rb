class UsersController < ApplicationController
    def show
        # binding.pry
        @user = User.find(params[:id])
        @products = Product.includes(:group).where(user_id: @user.id)
    end
end
