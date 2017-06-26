class GroupsController < ApplicationController
  before_action :move_to_index, except: [:index, :show, :top, :intro, :search_top]
  before_action :set_group, only: [:show, :edit, :update, :destroy]


  def intro
    # binding.pry
  end

  def top
    @groups = []
    @group = Group.new
    @product = Product.new
    rank_dict = Comment.group(:product_id).order('sum_good DESC').limit(10).sum(:good)
    product_ids = rank_dict.keys
    @ranking_values = rank_dict.values
    @ranking = product_ids.map{|id| Product.find(id)}
  end

  def search_top
    group_keyword = params[:group_keyword]
    title_keyword = params[:title_keyword]
    # binding.pry
    if params[:title_keyword].present?
      #args = ["select * from Products p join Groups g on g.id = p.group_id where p.title LIKE ? and g.name LIKE ?","%#{title_keyword}%","%#{group_keyword}%"]
      #sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
      #@groups = []
      redirect_to :controller => 'products', :action => "index_all", :group_keyword => group_keyword, :title_keyword => title_keyword
      #@products =  ActiveRecord::Base.connection.select_all(sql)
      #@products = Product.where('title LIKE(?)', "%#{title_keyword}%")
    else
      @products = []
      if params[:group_keyword].present?
     #@groups = Group.where('name LIKE(?)', "%#{group_keyword}%")
        redirect_to :controller => 'groups', :action => "index", :group_keyword => group_keyword
      else
        redirect_to :controller => 'groups', :action => "top"
      end
     # redirect_to :controller => 'groups', :action => "index", :group_keyword => group_keyword
     # redirect_to :controller => 'groups', :action => "top"


    end
  end

  def index
    # binding.pry
    @group_keyword = params[:group_keyword]
    @groups = Group.where('name LIKE(?)', "%#{params[:group_keyword]}%").page(params[:page]).per(10)
    # @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    redirect_to group_products_path group_id: params[:id]
    #@titles = Product.where(group_id: params[:id])
  end

  # GET /groups/new
  def new
    @group = Group.new
    # binding.pry
    if params[:name]
      @group.name = params[:name]
      @product_id = params[:product_id]
      @product = Product.find(@product_id)
      @title = params[:title]
    end
  end

  # GET /groups/1/edit
  def edit
  end

  def search_group
    # binding.pry
    @keyword = params[:keyword]
    if params[:keyword].present?
      @groups = Group.where('name LIKE(?)', "%#{params[:keyword]}%").page(params[:page]).per(10)
    else
      @groups = []
    end
  end



  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.save
    # binding.pry
    product = params.require(:group)[:product]
    if product
      @product = Product.find(product[:product_id])
      @product_id = product[:product_id]
      @title = product[:title]
      if @group.errors.messages.length > 0
        # binding.pry
        # render :action => "new", locals: {:product_id => product[:product_id], :title => product[:title]}
        # render :controller => 'products', :action => "edit", :id => product[:product_id]
        # redirect_to :controller => 'products', :action => "edit", :id => product[:product_id]

        # @product = Product.find(product[:product_id])
        # @edit_error_message = @group.errors.messages
        render 'new'
        # render template: "products/edit", :id => product[:product_id]
      else
        # binding.pry
        product_updating = Product.find(product[:product_id])
        product_updating.update_attributes(group_id: @group.id, title: product[:title])
        redirect_to :controller => 'products', :action => "show", :id => product[:product_id]
      end
    else
      # binding.pry
      unless @group.errors.messages.length > 0
        tmp_group = Group.find_by(name: params[:group][:name])
        # binding.pry
        if tmp_group
          tmp_group_id = tmp_group.id
          redirect_to :controller => 'products', :action => "create_title", group_id: tmp_group_id
        else
          render 'new'
        end
      else
        render 'new'
      end
    end


    # respond_to do |format|
    #   if @group.save
    #     #format.html { redirect_to @group, notice: 'Group was successfully created.' }
    #     #format.json { render :show, status: :created, location: @group }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @group.errors, status: :unprocessable_entity }
    #   end
    # end
    # redirect_to controller: 'products', action: 'create_title'
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :boke, :tsukkomi)
    end
    def move_to_index
        unless user_signed_in?
            redirect_to controller: 'groups', action: 'top'
        end
    end
end
