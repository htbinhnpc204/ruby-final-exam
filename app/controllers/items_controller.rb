class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  helper_method :sort_column, :sort_direction
  skip_before_action :verify_authenticity_token

  # GET /items or /items.json
  def index
    @items = Item.order(sort_column + " " + sort_direction)
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
    @validated = validate_params
    logger.debug @validated
    respond_to do |format|
      if @validated
        if @item.save
          format.html { redirect_to item_url(@item), notice: "Item was successfully created." }
          format.json { render :show, status: :created, location: @item }
        end
      else
        @error = "Null excepted"
        format.html { render :new, status: :unprocessable_entity }
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
