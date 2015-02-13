class BranchAddressesController < ApplicationController
  def for_web_customer
    ref = Customer.find(params[:id]).ref

    branch_addresses_array = DesktopCustomerSiteAddress.where(customerref: ref).select(:id, :add1)

    branch_addresses = {}

    branch_addresses_array.each do |address|
      branch_addresses[address.id] = address.add1
    end

    render :json => branch_addresses
  end

  def create
    @branch_address = DesktopCustomerSiteAddress.new(create_params)
    if @branch_address.save
      render :json => { :success => true, :new_id => @branch_address.id }
    end
  end

  def destroy
    branch_address = DesktopCustomerSiteAddress.find(params[:id])

    render :json => { :success => branch_address.destroy }
  end

  def update
    render :json => {
      :success => DesktopCustomerSiteAddress.find(params[:id]).update(update_params)
    }
  end

  def show
    branch_address = DesktopCustomerSiteAddress.find(params[:id])

    respond_to do |format|
      format.json { render :json => {
        :add1        => branch_address.add1,
        :add2        => branch_address.add2,
        :add3        => branch_address.add3,
        :add4        => branch_address.add4,
        :add5        => branch_address.add5,
        :description => branch_address.description,
        :tel         => branch_address.tel,
        :fax         => branch_address.fax,
        :email       => branch_address.email,
        :contact     => branch_address.contact
      } }
    end
  end

  private
  def create_params
    params[:branch][:add1] ||= "New Address"
    params[:branch].permit(
      :add1, :add2, :add3, :add4, :add5, :description, :tel, :fax, :email,
      :contact, :customerref
      )
  end

  def update_params
    params[:branch].permit(
      :add1, :add2, :add3, :add4, :add5, :description, :tel, :fax, :email,
      :contact
      )
  end
end

