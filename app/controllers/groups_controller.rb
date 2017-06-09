class GroupsController < ApplicationController
  before_action :move_to_index, except: [:index, :show, :top]
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def top
  end

  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    redirect_to group_products_path group_id: params[:id]
    #@titles = Product.where(group_id: params[:id])
  end

  # GET /groups/new
  def new
    #binding.pry
    @group = Group.new
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
    keyword = "%#{params[:keyword]}%"
    if params[:keyword].present?
      @groups = Group.where('name LIKE(?)', "%#{params[:keyword]}%").limit(20)
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
      #binding.pry
      product_updating = Product.find(product[:product_id])
      product_updating.update_attributes(group_id: @group.id, title: product[:title])
      redirect_to :controller => 'products', :action => "show", :id => product[:product_id]
    else
      tmp_group_id = Group.find_by(name: params[:group][:name]).id
      redirect_to :controller => 'products', :action => "create_title", group_id: tmp_group_id
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
