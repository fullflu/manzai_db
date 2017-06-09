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
            if comment.prev_id
                prev_comment = Comment.find(comment.prev_id)
            else
                prev_comment = nil
            end
            if comment.post_id
                post_comment = Comment.find(comment.post_id)
            else
                post_comment = nil
            end
            if post_comment
                post_comment.prev_id = comment.prev_id
                post_comment.save
            end
            if prev_comment
                prev_comment.post_id = comment.post_id
                prev_comment.save
            end
            product_id = comment.product_id
            comment.destroy
            #binding.pry
            redirect_to controller: :products, action: :show, id: product_id
        end
    end

    private
    def create_params
        #binding.pry
        # params.require(:comment).permit(:daihon).merge(product_id: params[:product_id])
        params.require("comment").permit(:daihon).merge(product_id: params[:product_id],tsukkomi: params.require("comment")[:tsukkomi], prev_id: params.require("comment")[:prev_id])
    end
end
