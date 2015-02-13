class AssetsController < ApplicationController
include GridData	

	def index
		@section_name_override="Equipment Register"
	end

	def gridajaxdata
		fieldslist=["name","make","model","type","status","serial_no","locationdescription","installation_date","decomission_date","notes"]
		strjoins=""
		render :json => getGridData(Assets,params,fieldslist,'id',strjoins,"",nil,[])
	end

	def create

	end

	def new
		@section_name_override="Equipment Record"		
		@asset = Assets.new
	end


	def show
		@section_name_override="Equipment Record"		
		@asset = Assets.find(params[:id])
	end

end