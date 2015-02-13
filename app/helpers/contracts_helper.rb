module ContractsHelper
  def status_select_options
    options = ""
    DesktopContractStatus.select(:id, :statusname).each do |status|
      options << "<option value=\"#{status.id}\""
      options << " selected" if @contract.status == status.id
      options << ">#{status.statusname}</option>"
    end
    return options
  end

  def work_ref_pretty(work)
    ref = work.ref
    ref = "(Self)" if ref == "-1"
    return ref
  end

  def set_view_baseline
    @eligible_subbies = []
    @related_works    = []
    @site_addresses   = []
    @notes            = []
    @quotes           = []
    @quote_ids        = []

    @customers = DesktopCustomer.select(:ref, :name)

    @subbie_defaults = DesktopDefault.select(
                        :tblCDefaults_RetP,
                        :tblCDefaults_RetPeriod,
                        :tblCDefaults_DisP
                        ).first
  end
end
