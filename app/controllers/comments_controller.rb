class CommentsController < ApplicationController
    def new
        @product = Product.find(params[:product_id])
        @comment = Comment.new
    end

    def create
        #binding.pry
        new_comment = Comment.create(create_params)
        #binding.pry
        #comment_view = Comment.find(params[:prev_id])
        #comment_view.update(post_id: )
        # redirect_to controller: :products, action: :index, group_id: Product.find(params[:product_id]).group_id
        if new_comment.prev_id
            update_comment = Comment.find(new_comment.prev_id)
            update_comment.update_attribute(:post_id, new_comment.id)
        end
        redirect_to controller: :products, action: :show, id: params[:product_id]
    end

    def destroy
        comment = Comment.find(params[:id])
        if comment.product.user_id == current_user.id
            comment.destroy
        end
    end

    private
    def create_params
        #binding.pry
        # params.require(:comment).permit(:daihon).merge(product_id: params[:product_id])
        params.require("comment").permit(:daihon).merge(product_id: params[:product_id],tsukkomi: params.require("comment")[:tsukkomi], prev_id: params.require("comment")[:prev_id])
    end
end
