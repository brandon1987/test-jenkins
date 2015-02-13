class AssetStatusController < ApplicationController


	def delete
		asset=AssetStatus.find(params[:id])
		if asset
			asset.destroy
			render :json => {:success => true}			
		end
	end


	def add
		asset=AssetStatus.new
		asset.status_name=params[:name]
		if asset.save
			render :json => {:success => true}
		else
			render :json => {:success => false}
		end
	end

end