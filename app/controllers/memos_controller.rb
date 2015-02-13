class MemosController < ApplicationController
  def create
    new_memo = DesktopMemo.new(create_params)
    success = new_memo.save
    
    render :json => {
      :success => success,
      :memo_id => new_memo.id
    }
  end

  def destroy
    render :json => {
      :success => DesktopMemo.destroy(params[:id])
    }
  end

  private
  def create_params
    params[:memo].permit(
      :details, :related_id, :memo_type
    )
  end
end