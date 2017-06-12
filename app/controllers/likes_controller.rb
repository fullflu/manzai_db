class LikesController < ApplicationController
    def create
        # binding.pry
        @like = Like.create(user_id: current_user.id, comment_id: params[:id])
        @likes = Like.where(comment_id: params[:id])
        @comment = Comment.find(params[:id])
        # respond_to do |format|
        #     format.js
        # end
        # binding.pry
        # @comments = Product.where(comment_id: params[:])
    end

    def destroy
        # binding.pry
        like = Like.find_by(user_id: current_user.id, comment_id: params[:id])
        like.destroy
        @likes = Like.where(comment_id: params[:id])
        @comment = Comment.find(params[:id])
        # respond_to do |format|
        #     format.js
        # end
    end
end
