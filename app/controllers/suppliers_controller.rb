include InviteHelper
include SettingsHelper

class SuppliersController < ApplicationController
  def get_template_members # params[:template_id]
    subbie_ids = DesktopSubbieItem.where(template_id: params[:template_id]).pluck(:cis_ref)

    other_subbie_ids = DesktopSupplier.eligible_subbies.pluck(:ref)

    other_subbie_ids -= subbie_ids

    render :json => {
      included:     subbie_ids,
      not_included: other_subbie_ids
    }
  end

  def update_template
    DesktopSubbieItem.where(template_id: params[:id]).destroy_all

    params[:subbie_refs].each do |ref|
      DesktopSubbieItem.new(cis_ref: ref, template_id: params[:id]).save
    end

    render :json => { :success => true }
  end

  def destroy_template
    if DesktopSubbieTemplate.find(params[:id]).destroy
      DesktopSubbieItem.where(template_id: params[:id]).destroy_all
      render :json => { :success => true }
    else
      render :json => { :success => false }
    end
  end

  def create_template
    new_template = DesktopSubbieTemplate.new(name: params[:name])

    render :json => {
      :success => new_template.save,
      :new_id  => new_template.id
    }
  end
end
