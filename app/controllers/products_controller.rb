class ProductsController < ApplicationController
  def new
    @product = StockItem.new
  end

  def index
    @products = StockItem.all
  end

  def show
    @product = StockItem.find(params[:id]);
  end

  def create
    @product = StockItem.new(request.POST)
    @product.save

    respond_to do |format|
      format.html { render :text => @product.id }
    end
  end

  def update
    render :json => {
      :success => StockItem.find(params[:id]).update(update_params)
    }
  end

  def destroy
    ids = params[:id].split(",")
    StockItem.where(id: ids).destroy_all

    render :json => { :success => true }
  end

  def get_product_list_json
    render :json => ProductsHelper::product_list
  end

  def get_product_details
    product = StockItem.where(code: params[:code]).select(
      :short_description, :long_description, :unit_cost
      ).first

    render :json => product
  end

  def upload_stock_file
    csv_data = params[:file].tempfile
    csv_data.each_with_index do |csv_line, index|
      next if index == 0 and params[:skip_first] == "1"

      next  if index < params[:from].to_i - 1
      break if index > params[:to].to_i - 1

      line_items = csv_line.split(",")

      product_items = {
        :code              => line_items[params["products-columns"]["stockcode"].to_i],
        :short_description => line_items[params["products-columns"]["description"].to_i],
        :long_description  => line_items[params["products-columns"]["longdescription"].to_i],
        :unit_cost         => line_items[params["products-columns"]["costprice"].to_i],
        :unit_type         => line_items[params["products-columns"]["unitofsale"].to_i]
      }

      @stock_item = StockItem.find_or_create_by(code: product_items[:code])
      @stock_item.update_attributes(product_items)
    end

    render :json => {:success => true}
  end

  def import_from_sage
    interactor = SageInteractor.get_by_company_id(session[:company_id])

    sage_data = interactor.get_all_stock_data

    sage_data.each do |stock_item|
      stock_item = JSON.parse(stock_item[1])

      new_item = StockItem.find_or_create_by(code: stock_item["STOCK_CODE"])

      new_item.update({
        :short_description => stock_item["DESCRIPTION"],
        :long_description  => stock_item["WEB_LONGDESCRIPTION"],
        :unit_cost         => stock_item["SALES_PRICE"],
        :unit_type         => stock_item["UNIT_OF_SALE"]
        })
    end

    render :json => { :success => 1}
  end

  private
  def update_params
    params.permit(
      :code, :short_description, :long_description, :unit_cost, :unit_type
    )
  end
end