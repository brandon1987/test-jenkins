class AssetTypesController < ApplicationController


	def delete
		asset=AssetType.find(params[:id])
		if asset
			asset.destroy
			render :json => {:success => true}			
		end
	end


	def add
		asset=AssetType.new
		asset.type_name=params[:name]
		if asset.save
			render :json => {:success => true}
		else
			render :json => {:success => false}
		end
	end

end