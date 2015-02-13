module QuotesHelper
  def attachment_label(quote)
    if not quote.xid_contract.nil?
      "Contract ##{quote.xid_contract}"
    else
      ""
    end
  end

  def attachment_link(quote)
    if quote.xid_contract
      contract_ref = @contract_refs.select { |x| x[0] == quote.xid_contract }[0][1]
      "<a href=\"/contracts/#{quote.xid_contract}\">[C] #{contract_ref}</a>"
    else
      ""
    end
  end

  def reports_enabled?
    !JSON.parse(getAmazonFileList("reports")).empty?
  end

  def edit_label
    @access_rights["quotes_add"] ? "Edit" : "View"
  end

  def quote_address
    if @quote.xid_customer && @quote.xid_customer != -1
      customer = Customer.find(@quote[:xid_customer])
      if @quote.branch_address_id == -1
        formatted_address(customer)
      else
        formatted_branch_address
      end
    end
  end

  def formatted_branch_address
    branch_address = DesktopCustomerSiteAddress.find(@quote.branch_address_id)

    address = ""

    address << [
      branch_address.add1,
      branch_address.add2,
      branch_address.add3,
      branch_address.add4,
      branch_address.add5
    ].reject { |x| x.nil? or x == "" }.join("\n")

    address << "\n"

    address << [
      branch_address.tel
    ].reject { |x| x.nil? or x == "" }.join("\n")

    return address.chomp
  end
end
