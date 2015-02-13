class TenderTemplatesController < ApplicationController
  def create
    template = DesktopTenderTemplate.new(tender_template_params)
    render :json => {
      :success => template.save,
      :new_id  => template.id
    }
  end

  def update
    render :json => {
      :success => DesktopTenderTemplate.find(params[:id]).update(tender_template_params)
    }
  end

  def destroy
    render :json => {
      :success => DesktopTenderTemplate.find(params[:id]).destroy
    }
  end

  def create_from_contract
    DesktopTenderTemplate.create_from_contract(params[:contract_id])
    render :json => {:success => true }
  end

  def get_tree
    @tenders = DesktopTenderTemplateItem.groups
                      .select(:id, :details, :group_id)
                      .where(template_id:     params[:id])

    data = []

    @tenders.each do |tender|
      entry = {
        :id   => "desktop_tender_template_item_#{tender.id}",
        :text => tender.details
      }

      entry[:parent] = tender.group_id == -1 ? "#" : "desktop_tender_template_item_#{tender.group_id}"
      entry[:state]  = { :opened => true } if tender.group_id == -1

      data << entry
    end

    respond_to do |format|
      format.json { render :json => data }
    end
  end

  def grid_data
    tenders = DesktopTenderTemplateItem.select(
      :id,
      :ref,
      :details,
      :amount)
    .where(group_id: params[:branch_id])
    .where.not(ref: "GROUP")

    data = []

    tenders.each do |tender|
      data << {
        "DT_RowId" => "desktop_tender_#{tender.id}",
        0 => tender.ref,
        1 => tender.details,
        2 => tender.amount
      }
    end

    rows = {
      "aaData" => data
    }

    render :json => rows
  end

  def set_default
    render :json => {
      :success => CompanyPreferences.default_tender_template = params[:id]
    }
  end

  private
  def tender_template_params
    params.permit(:name)
  end
end