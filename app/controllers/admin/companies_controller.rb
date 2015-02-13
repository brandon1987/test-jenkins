class Admin::CompaniesController < AdminController
  def index
    @companies = Company.all
  end

  def show
    @company    = Company.find(params[:id])
    @users      = User.where(:xid_company => params[:id])
    @permission = Permission.find_by(:id_company => params[:id])
    @invites    = Invite.where(company_id: params[:id]).order(:recipient)

    if @permission.nil?
      @permission = Permission.new
      @permission.id_company = @company.id
      @permission.save
    end
  end

  def create
    @company = Company.new({
        :display_name => request.POST["new_company_name"]
      })

    if @company.save
      redirect_to("/admin/companies/#{@company.id}")
    else
      redirect_to("/admin/companies")
    end
  end

  def enable_permission
    @permission = Permission.find_by(:id_company => params[:id])
    @permission[params[:type]] = 1
    @permission.save
    redirect_to("/admin/companies/#{params[:id]}")
  end

  def disable_permission
    @permission = Permission.find_by(:id_company => params[:id])
    @permission[params[:type]] = 0
    @permission.save
    redirect_to("/admin/companies/#{params[:id]}")
  end
end