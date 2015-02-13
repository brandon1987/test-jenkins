class TenderTemplateItemsController < ApplicationController
  def create_group
    group = DesktopTenderTemplateItem.new(item_params)
    group.is_group = -1
    group.ref = "GROUP"

    render :json => { :success => group.save }
  end

  def update
    render :json => {
      :success => DesktopTenderTemplateItem.find(params[:id]).update(item_params)
    }
  end

  def destroy
    all_ids = [params[:id].to_i]

    these_ids = DesktopTenderTemplateItem.where(group_id: params[:id]).pluck(:id)

    until these_ids.empty?
      all_ids += these_ids
      these_ids = DesktopTenderTemplateItem.where(group_id: these_ids).pluck(:id)
    end

    render :json => {
      :success => true,
      :undeleted => DesktopTenderTemplateItem.where(id: all_ids).destroy_all
    }
  end

  def import
    csv_data = params[:file].tempfile

    tender_items = []

    csv_data.each_with_index do |csv_line, index|
      next if index == 0 and params[:skip_first] == "1"
      next  if index < params[:from].to_i - 1
      break if index > params[:to].to_i - 1

      line_items = csv_line.split(",")

      columns = params["tendertemplateitems-columns"].reject { |k, v| v == "-1" }

      column_map = {
        "ref"     => :ref,
        "details" => :details,
        "amount"  => :amount
      }

      tender_items = {
        template_id: params[:template_id],
        group_id:    params[:group_id]
      }

      columns.each do |k, v|
        tender_items[column_map[k]] = line_items[v.to_i].chomp
      end

      DesktopTenderTemplateItem.new(tender_items).save
    end

    render :json => { :success => true }
  end

  private
  def item_params
    params.permit(:ref, :amount, :details, :template_id, :group_id)
  end
end