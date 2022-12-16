class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  helper_method :sort_column, :sort_direction
  skip_before_action :verify_authenticity_token

  ITEM_PER_PAGE = 3

  # GET /items or /items.json
  def index
    @items = current_user.items
    if params[:query]
      @query = params[:query]
      @items = @items.where('item_name LIKE ?', "%#{@query}%")
    end
    @page = params.fetch(:page, 0).to_i
    @total_pages = (@items.length * 1.0 / ITEM_PER_PAGE).ceil
    @items = @items.offset(@page * ITEM_PER_PAGE).limit(ITEM_PER_PAGE)
    respond_to do |format|
      format.html
      format.json { render json: @items }
    end
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    @validated = validate_params
    logger.debug @validated
    respond_to do |format|
      if @validated
        if @item.save
          format.html { redirect_to item_url(@item), notice: "Item was successfully created." }
          format.json { render :show, status: :created, location: @item }
        end
      else
        flash[:error] = 'Null excepted'
        format.html { redirect_to new_item_url }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    @validated = validate_params
    respond_to do |format|
      if @validated
        if @item.update(item_params)
          format.html { redirect_to item_url(@item), notice: "Item was successfully updated.", item_id: @item.id }
          format.json { render :show, status: :ok, location: @item }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  def validate_params
    item_params.each do |param|
      if param[1].blank?
        return false
      end
    end
    true
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:item_name, :item_qty, :item_des)
  end

  def sort_column
    Item.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
