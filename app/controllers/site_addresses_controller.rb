include NullStrippable

class SiteAddressesController < ApplicationController
  def index
    @site_addresses = DesktopSiteAddress.select(
      :id, :name, :address_1, :description
    ).select("tblContractXidJobNo AS job_no")
    .joins("LEFT JOIN tblcontracts ON tbladdresses.tblAddresses_XIDContract = tblcontractid")
  end

  def create_for_contract
    @site_address = DesktopSiteAddress.new

    @site_address.contract_id = params[:contract_id]
    @site_address.name        = "New address"

    if @site_address.save
      render :text => @site_address.id
    else
      render :text => -1
    end
  end

  def create
    @site_address = DesktopSiteAddress.new(update_params)
    if @site_address.save
      render :json => { :success => true, :new_id => @site_address.id }
    end
  end

  def new
    @site_address = DesktopSiteAddress.new
  end
  
  def show
    @site_address = DesktopSiteAddress.find(params[:id])

    strip_nulls_from_record(@site_address)

    respond_to do |format|
      format.html
      format.json { render :json => @site_address }
    end
  end

  def destroy
    render :json => {
      :success => DesktopSiteAddress.find(params[:id]).destroy
    }
  end

  def update
    render :json => {
      :success => DesktopSiteAddress.find(params[:id]).update(update_params)
    }
  end

  private
  def update_params
    params[:address].permit(
      :id, :ref,:contract_id, :name, :address_1, :address_2, :address_3,
      :address_4, :address_5, :description ,:tel, :fax, :email, :contact,
      :work_phone, :home_phone, :mobile_phone, :analysis_1, :analysis_2,
      :analysis_3)
  end
end