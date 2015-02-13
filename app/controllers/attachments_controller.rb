# encoding: UTF-8
include FormatHelper
include AmazonStorage

class AttachmentsController < ApplicationController
  def get
    file_data = getAmazonFile("#{params[:section]}/#{params[:id]}", params[:filename])
    send_data(file_data, :filename => params[:filename], :disposition => "attachment")
  end

  def create
    begin
      saveAmazonFile("#{params[:section]}/#{params[:id]}",params[:userfile].original_filename ,params[:userfile].read)
      render :json => {:success => true,:uploadno => params[:uploadno]}
    rescue StandardError => msg
      puts msg
      render :json => {:success => false,:uploadno => params[:uploadno],:error => msg}
    end
  end

  def destroy
    begin
      deleteAmazonFile("#{params[:section]}/#{params[:id]}", params[:filename])
      render :json => {:success => true, :filename => params[:filename]}
    rescue StandardError => msg
      render :json => {:success => false,:filename => params[:filename],:error => msg}
    end
  end
end
