class CommentsController < ApplicationController
    before_action :move_to_index, except: [:index, :show, :index_all]
    def new
        @product = Product.find(params[:product_id])
        @comment = Comment.new
    end

    def add
        @post_comment = Comment.find(params[:id])
        @product = Product.find(@post_comment.product_id)
        if current_user.id != @product.user_id
            redirect_to controller: :products, action: :show, id: @product.id
        end

        if @post_comment.prev_id
            @prev_comment = Comment.find(@post_comment.prev_id)
            @prev_comment_id = @prev_comment.id
        end
        @tsukkomi_flg = !@post_comment.tsukkomi
        if @tsukkomi_flg
            @tsukkomi = "#{@product.group.tsukkomi}（つっこみ）"
        else
            @tsukkomi = "#{@product.group.boke}（ぼけ）"
        end
        @comment = Comment.new
    end

    def create
        # binding.pry
        new_comment = Comment.create(create_params)
        # binding.pry
        #comment_view = Comment.find(params[:prev_id])
        #comment_view.update(post_id: )
        # redirect_to controller: :products, action: :index, group_id: Product.find(params[:product_id]).group_id
        if new_comment.prev_id
            update_comment = Comment.find(new_comment.prev_id)
            update_comment.update_attribute(:post_id, new_comment.id)
        end
        if new_comment.post_id
            update_comment = Comment.find(new_comment.post_id)
            update_comment.update_attribute(:prev_id, new_comment.id)
        end
        redirect_to controller: :products, action: :show, id: params[:product_id]
    end

    def update
        # binding.pry
        comment = Comment.find(params[:id])
        if comment.product.user_id == current_user.id
            comment.update_attribute(:daihon, update_params[:daihon])
        end
        redirect_to controller: :products, action: :show, id: comment.product_id
    end

    def edit
        @comment = Comment.find(params[:id])
        if current_user.id != @comment.product.user_id
            redirect_to controller: :products, action: :show, id: @comment.product_id
        end
        if @comment.prev_id
            @prev_comment = Comment.find(@comment.prev_id)
        end
        if @comment.post_id
            @post_comment = Comment.find(@comment.post_id)
        end
        # binding.pry
        #redirect_to controller: :products, action: :show, id: @comment.product_id
    end

    def destroy
        comment = Comment.find(params[:id])
        if current_user.id != comment.product.user_id
            redirect_to controller: :products, action: :show, id: comment.product_id
        end
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
        params.require("comment").permit(:daihon).merge(product_id: params[:product_id],tsukkomi: params.require("comment")[:tsukkomi], prev_id: params.require("comment")[:prev_id], post_id: params.require("comment")[:post_id])
    end
    def update_params
        params.require("comment").permit(:daihon)
    end
    def move_to_index
        unless user_signed_in?
            redirect_to controller: 'groups', action: 'top'
        end
    end
end
