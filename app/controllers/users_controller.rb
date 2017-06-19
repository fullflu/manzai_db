class UsersController < ApplicationController
    def show
        # binding.pry
        @user = User.find(params[:id])
        @products = Product.includes(:group).where(user_id: @user.id)
    end

  #   def edit
  #       # binding.pry
  #       @user = User.find(params[:id])
  #   end

  #   def update
  #       binding.pry
  #       @user =User.find(params[:id])
  #       if @user.update_attributes(user_params)
  #           redirect_to controller: 'users', action: 'show', :id => params[:id]
  #       else
  #           render 'edit'
  #       end
  #   end

  #   def delete
  #       binding.pry
  #       redirect_to controller: 'users', action: 'show', :id => params[:id]
  #   end

  # private

  #   def user_params
  #     params.require(:user).permit(:nickname, :email, :password,
  #                                  :password_confirmation)
  #   end
end
