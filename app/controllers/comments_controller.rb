class CommentsController < ApplicationController
    def new
        @product = Product.find(params[:product_id])
        @comment = Comment.new
    end

    def create
        # binding.pry
        Comment.create(create_params)
        # redirect_to controller: :products, action: :index, group_id: Product.find(params[:product_id]).group_id
        redirect_to controller: :products, action: :show, id: params[:product_id]
    end

    private
    def create_params
        # params.require(:comment).permit(:daihon).merge(product_id: params[:product_id])
        params.permit(:daihon).merge(product_id: params[:product_id])
    end
end
