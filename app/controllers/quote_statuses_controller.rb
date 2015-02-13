class QuoteStatusesController < ApplicationController
  def create
    status = QuoteStatus.new(status_params)
    render :json => { :success => status.save }
  end

  def index
    @statuses = QuoteStatus.all

    respond_to do |format|
      format.json { get_grid_json }
    end
  end

  def update
    render :json => {
      :success => QuoteStatus.find(params[:id]).update(status_params)
    }
  end

  def destroy
    render :json => {
      :success => QuoteStatus.find(params[:id]).destroy
    }
  end

  # PATCH /quote_statuses/:id/set_default
  def set_default
    render :json => {
      :success => QuoteStatus.find(params[:id]).make_default
    }
  end

  private
  def get_grid_json
    render :json => {
      "aaData" => @statuses.map do |status|
        x = {
          "DT_RowId" => "quote_status_#{status.id}",
          0          => status.name,
          1          => status.is_default,
          2          => status.is_hidden
        }
        x
      end
    }
  end

  def status_params
    params[:status].permit(:name, :is_hidden, :is_default)
  end
end
