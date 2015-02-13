class PartialController < ApplicationController
	def partialrender()
		render :partial =>"#{params[:partialname]}", locals: params
	end
end