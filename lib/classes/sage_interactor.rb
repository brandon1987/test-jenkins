class SageInteractor
  def SageInteractor.get_by_company_id(company_id)
    company = Company.where(id: company_id).select(
      :sage_integration_url,
      :sage_integration_password
    ).first

    return SageInteractor.new(
      company.sage_integration_url,
      company.sage_integration_password
      )
  end

  def initialize(address, password)
    address  ||= ""
    password ||= ""
    @connection = SageConnector.new(address, password)
  end

  def debug?
    @connection.debug?
  end

  def debug=(value)
    @connection.debug = value
  end

  def test_connection
    @connection.test_connection
  end

  # Takes an AR instance of a desktop_customer and inserts the data into sage
  def upsert_customer(customer)
    fields = {
      "ACCOUNT_REF" => customer.ref
    }

    fields["ADDRESS_1"] = customer.address_1 if customer.address_1
    fields["ADDRESS_2"] = customer.address_2 if customer.address_2

    return @connection.post_data(
      "SalesRecord",
      "CreateRecord",
      fields.to_json
      )
  end

  def update_customer(customer)
    puts "TODO: IMPLEMENT ME (sage_interactor.rb#update_customer)"
  end

  def post_sales_invoice(data)
    return @connection.post_data(
      "InvoicePost",
      "Post",
      data.to_json
      )
  end

  def get_department_data(company_id)
    return @connection.post_data(
      "DepartmentData",
      "GetByIndex",
      company_id
      )
  end

  def get_next_invoice_number
    return @connection.post_data(
      "DepartmentData",
      "GetNextInvoiceNumber"
      )
  end

  def get_all_stock_data
    required_fields = {
        0 => "STOCK_CODE",
        1 => "DESCRIPTION",
        2 => "WEB_LONGDESCRIPTION",
        3 => "SALES_PRICE",
        4 => "UNIT_OF_SALE"
      }

    data = @connection.get_data(
      "StockData",
      "GetAllObjectData",
      required_fields.to_json)

    return JSON.parse(data)
  end
end
