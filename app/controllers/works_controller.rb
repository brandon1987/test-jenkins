include ContractsHelper
include FormatHelper

class WorksController < ApplicationController
  def show
    render :json => DesktopWork.find(params[:id])
  end

  def create
    @work = DesktopWork.new(create_params)

    @supplier = DesktopSupplier.select(:name).where(ref: params[:work][:ref]).first
    @work.contractor_name = @supplier.name

    @work.contract_id = params[:contract_id]
    @work.number = DesktopWork.next_number_for_contract(params[:contract_id])

    render :json => {
      :success => @work.save
    }
  end

  def update
    @work = DesktopWork.find(params[:work_id])

    render :json => {
      :success => @work.update(update_params)
    }
  end

  def grid_data_for_contract
    subbies = DesktopWork
                .where(contract_id: params[:contract_id])
                .select(:number, :ref, :contractor_name, :date_started, :details, :retention)

    respond_to do |format|
      format.html { grid_data_as_html(subbies) }
      format.js   { grid_data_as_json(subbies) }
    end
  end

  def grid_data_as_html(subbies)
    @subbies = subbies
    render "works/printable_list", layout: nil
  end

  def grid_data_as_json(subbies)
    data = []

    subbies.each do |work|
      data << {
        "DT_RowId" => "desktop_work_#{work.id}",
        0 => work.number,
        1 => work_ref_pretty(work),
        2 => work.contractor_name,
        3 => date_format(work.date_started),
        4 => work.details,
        5 => work.retention
      }
    end

    rows = {
      "aaData" => data
    }

    render :json => rows
  end

  private
  def create_params
    params[:work].permit(
      :ref, :retention, :ret_period, :discount_percentage, :discount_method
      )
  end

  def update_params
    params[:work].permit(
      :retention, :ret_period, :discount_percentage, :discount_method
      )
  end
end
