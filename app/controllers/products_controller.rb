class ProductsController < ApplicationController
  before_action :move_to_index, except: [:index, :show, :index_all, :dl_test]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    # binding.pry
    @title_keyword = params[:title_keyword]
    @group = Group.find_by(id: params[:group_id])
    #@products = Product.where(group_id: params[:group_id]).includes([:group, :user])
    @products = Product.includes([:group,:user]).where('products.group_id = ? && products.title LIKE(?)', "#{params[:group_id]}", "%#{params[:title_keyword]}%")
  end

  def index_all
    # binding.pry
    @group_keyword = params[:group_keyword]
    @title_keyword = params[:title_keyword]
    # binding.pry
    @products = Product.includes([:group,:user]).joins(:group).where('products.title LIKE(?) && groups.name LIKE(?)', "%#{params[:title_keyword]}%","%#{params[:group_keyword]}%")
    # @products = Product.all.includes([:group, :user])
    #binding.pry
  end

  def dl_test
    # binding.pry
    if params[:group_id]
      to_tsv
      redirect_to :controller => 'products', :action => 'index', :group_id => params[:group_id]
    elsif params[:id]
      product = Product.find(params[:id])
      product_to_tsv(product)
      redirect_to :controller => 'products', :action => 'show', :id => params[:id]
    else
      to_tsv
      redirect_to :controller => 'products', :action => 'index_all'
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    # binding.pry
    comments = @product.comments
    comment_id = comments.select("id")
    comment_id = comment_id.map{|item| item.id}
    ary=[comment_id,comments].transpose
    comments_hash = ary.to_h
    comment_view = comments.find_by(prev_id: nil)
    @comments_view = []
    @comments_view << comment_view
    for i in 1..comment_id.length-1
      comment_view = comments_hash[comment_view.post_id]
      @comments_view << comment_view
    end
    # if params[:update_last]
    #   comment_view.update(post_id: params[:update_last])
    # end
    if comment_id.length == 0
      @tsukkomi_next_flg = 1
      @tsukkomi_next = "つっこみ"
    else
      if comment_view.tsukkomi
        @tsukkomi_next = "ぼけ"
      else
        @tsukkomi_next = "つっこみ"
      end
      @tsukkomi_next_flg = !comment_view.tsukkomi
      @last_id = comment_view.id
    end

    @comment = Comment.new
    #group_name = Product.find(params[:id]).group_id
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
    if current_user.id != @product.user_id
      redirect_to :controller => 'products', :action => 'show', id: params[:id]
    end
    @group = Group.find(@product.group_id)
    # binding.pry
    #group_id = Product.find(params[:id]).group_id
    #params[:group_id] = group_id
  end

  def edit_group
    group = Group.find(@product.group_id)
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    # binding.pry

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
    if @product.user_id == current_user.id
      #binding.pry
      new_group_name = params.require(:group)[:name]
      new_group = Group.find_by(name: new_group_name)
      if new_group
        @product.group_id = new_group.id
        respond_to do |format|
          if @product.update(product_params_edit)
            format.html { redirect_to @product, notice: 'Product was successfully updated.' }
            format.json { render :show, status: :ok, location: @product }
          else
            format.html { render :edit }
            format.json { render json: @product.errors, status: :unprocessable_entity }
          end
        end
      else
        redirect_to :controller => 'groups', :action => "new", name: new_group_name, product_id: params[:id], title: params.require(:product)[:title]
      end
    else
      redirect_to :controller => 'products', :action => 'show', id: params[:id]
    end

  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    if @product.user_id == current_user.id
      @product.destroy
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to :controller => 'products', :action => 'show', id: params[:id]
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
      #group_id = Product.find(params[:id]).group_id
      params.require(:product).permit(:title).merge(user_id: current_user.id, group_id: @product.group_id)
    end

    def move_to_index
        unless user_signed_in?
            redirect_to controller: 'groups', action: 'top'
        end
    end

    def to_tsv
      # binding.pry
      products = Product.where('id in (?)',params[:check_id_])
      if products
        products.each do |product|
          product_to_tsv(product)
        end
      end
    end

    def product_to_tsv(product)
        path = "../downloads/group_#{product.group_id}/"
        FileUtils.mkdir_p(path) unless FileTest.exist?(path)
        CSV.open(path+"product_#{product.id}.tsv", "w", :col_sep => "\t") do |io|
          io << ["daihon","tsukkomi"]
          comments = comments_sort(product)
          if comments
            comments.each do |x|
             io << [x[:daihon],x[:tsukkomi]]
            end
          end
        end
    end

    def comments_sort(product)
      comments = product.comments
      if comments.length == 0
        return nil
      end
      comment_id = comments.select("id")
      comment_id = comment_id.map{|item| item.id}
      ary=[comment_id,comments].transpose
      comments_hash = ary.to_h
      comment_view = comments.find_by(prev_id: nil)
      comments_view = []
      comments_view << comment_view
      for i in 1..comment_id.length-1
        comment_view = comments_hash[comment_view.post_id]
        comments_view << comment_view
      end
      return comments_view
    end

end
