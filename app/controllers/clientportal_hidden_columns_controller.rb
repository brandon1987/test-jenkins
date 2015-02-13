class ClientportalHiddenColumnsController < ApplicationController
  def getsettings


  end




  def settingchange
  	if params[:setting]=="true"
  		colrecord=ClientportalHiddenColumns.where(:customer_id=>params[:customerid],:section=>params[:section],:column=>params[:column]).first
		if colrecord
			ClientportalHiddenColumns.destroy(colrecord.id)
		end
  	else
  		colrecord=ClientportalHiddenColumns.where(:customer_id=>params[:customerid],:section=>params[:section],:column=>params[:column]).first_or_create
  		colrecord.customer_id=params[:customerid]
  		colrecord.section=params[:section]
  		colrecord.column=params[:column]
  		colrecord.column_selector=params[:columnselector]
  		colrecord.save
  	end
  	render :text=>"ok"
  end

end