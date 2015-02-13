class SavedGridFiltersController < ApplicationController

def savefilter
	filters=params[:filters]
	filters.each do |attr_name, attr_value|
		filterline=SavedGridFilter.where(:tablename => params[:tablename],:preset_name => params[:presetname],:column_title => attr_name).first_or_create
		filterline.filter_setting=attr_value
		filterline.save
	end
	render :text =>"ok"
end

def deletefilter
	SavedGridFilter.destroy_all(:preset_name => params[:presetname])
	render :text =>"ok"
end

end