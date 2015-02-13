class CompanyPreferencesController < ApplicationController
  def update
    render :json => {
      :success => CompanyPreferences.update(preferences)
    }
  end

  private
  def preferences
    params[:company_preferences].permit(
      :quote_num_to_contract_num, :quote_start_number
    )
  end
end
