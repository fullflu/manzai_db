class ProductsController < ApplicationController
  before_action :move_to_index, except: :index
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    #binding.pry
    @group = Group.find_by(id: params[:group_id])
    @products = Product.where(group_id: params[:group_id])
  end

  def index_all
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    #product = Product.find(params[:id])
  end

  def create_title
    @product = Product.new
    @product.user_id = current_user.id
    @product.group_id = params[:group_id]
    @group = Group.find_by(id: @product.group_id)
    #binding.pry
  end

  # GET /products/new
  def new
  end

  # GET /products/1/edit
  def edit
    #binding.pry
    #group_id = Product.find(params[:id]).group_id
    #params[:group_id] = group_id
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    #binding.pry

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params_edit)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      #binding.pry
      params.require(:product).permit(:title).merge(user_id: current_user.id, group_id: params[:group_id])
    end

    def product_params_edit
      #binding.pry
      group_id = Product.find(params[:id]).group_id
      params.require(:product).permit(:title).merge(user_id: current_user.id, group_id: group_id)
    end

    def move_to_index
        unless user_signed_in?
            redirect_to controller: 'groups', action: 'top'
        end
    end

end
