class TendersController < ApplicationController
  def grid_data
    tenders = DesktopTender.select(
      :id,
      :ref,
      :details,
      :cost_budget,
      :cost_budget_alert,
      :sales_budget,
      :tender_type,
      :percent_complete,
      :value_complete,
      :authorised)
    .where(parent_group_id: params[:tender_id])
    .where.not(ref: "Group")

    data = []

    tenders.each do |tender|
      next if ["T1", "T2", "T3"].include? tender.ref

      data << {
        "DT_RowId" => "desktop_tender_#{tender.id}",
        0 => tender.ref,
        1 => tender.details,
        2 => tender.cost_budget,
        3 => tender.cost_budget_alert,
        4 => tender.sales_budget,
        5 => tender.tender_type,
        6 => tender.percent_complete,
        7 => tender.value_complete,
        8 => tender.authorised
      }
    end

    rows = {
      "aaData" => data
    }

    render :json => rows
  end

  def get_tree
    @tenders = DesktopTender.groups
                      .select(:id, :details, :parent_group_id)
                      .where(contract_id:     params[:contract_id])

    data = []

    data << {
      :id     => "desktop_tender_-1",
      :text   => "Contract",
      :parent => "#",
      :state  => { :opened => true }
    }

    @tenders.each do |tender|
      entry = {
        :id   => "desktop_tender_#{tender.id}",
        :text => tender.details
      }

      entry[:parent] = tender.parent_group_id == -1? "desktop_tender_-1" : "desktop_tender_#{tender.parent_group_id}"

      data << entry
    end

    respond_to do |format|
      format.json { render :json => data }
    end
  end

  def create_group
    related_contract = DesktopContract.select(:job_no).where(id: params[:contract_id]).first

    group = DesktopTender.new({
      :ref             => "Group",
      :parent_group_id => params[:parent],
      :details         => params[:name],
      :contract_id     => params[:contract_id],
      :job_no          => related_contract.job_no,
      :is_group        => -1,
      :level           => params[:level]
      })

    render :json => { :success => group.save }
  end

  def destroy_group
    all_ids = [params[:id].to_i]

    these_ids = DesktopTender.where(parent_group_id: params[:id]).pluck(:id)

    until these_ids.empty?
      all_ids += these_ids
      these_ids = DesktopTender.where(parent_group_id: these_ids).pluck(:id)
    end

    render :json => {
      :success => true,
      :undeleted => DesktopTender.where(id: all_ids).destroy_all
    }
  end

  def update
    render :json => {
      :success => DesktopTender.find(params[:id]).update(tender_params)
    }
  end

  def create
    tender = DesktopTender.new(tender_params)

    render :json => {
      :success => tender.save
    }
  end

  def destroy
    render :json => {
      :success => DesktopTender.find(params[:id]).destroy
    }
  end

  def tender_params
    params.permit(
      :details, :parent_group_id, :contract_id, :ref, :cost_budget_alert,
      :tender_type, :authorised, :cost_budget, :sales_budget, :percent_complete,
      :value_complete)
  end

  def move_group
    success = DesktopTender.find(params[:id]).update({
      parent_group_id: params[:target],
      level:           params[:level]
      })

    render :json => { :success => success }
  end

  def move
    success = DesktopTender.find(params[:id]).update({
      parent_group_id: params[:target],
      })

    render :json => { :success => success }
  end

  def import
    csv_data = params[:file].tempfile

    tender_items = []

    csv_data.each_with_index do |csv_line, index|
      next if index == 0 and params[:skip_first] == "1"
      next  if index < params[:from].to_i - 1
      break if index > params[:to].to_i - 1

      line_items = csv_line.split(",")

      columns = params["tenders-columns"].reject { |k, v| v == "-1" }

      column_map = {
        "ref"         => :ref,
        "details"     => :details,
        "costbudget"  => :cost_budget,
        "salesbudget" => :sales_budget
      }

      tender_items = {
        contract_id:     params[:contract_id],
        parent_group_id: params[:parent]
      }

      columns.each do |k, v|
        tender_items[column_map[k]] = line_items[v.to_i].chomp
      end

      DesktopTender.new(tender_items).save
    end

    render :json => { :success => true }
  end
end