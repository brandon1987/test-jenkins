class SalesInvoicesController < ApplicationController
  def create
    @sales_invoice = DesktopSalesInvoice.new()
    @quote = Quote.find(params[:quote])
    @contract = DesktopContract.find(@quote.xid_contract)

    @sales_invoice.date        = @quote.date
    @sales_invoice.details     = "Work carried out as per quotation ##{@quote.id}"
    @sales_invoice.ncode       = @quote.customer.desktop_customer.default_ncode
    @sales_invoice.contract_id = @contract.id
    @sales_invoice.last_user   = session[:username]
    @sales_invoice.account_ref = @quote.customer.desktop_customer.ref
    @sales_invoice.job_ref     = @contract.job_no
    @sales_invoice.order_no    = "#{@quote.id}".first(7)

    if params[:full]
      create_full_invoice
    else
      create_part_invoice
    end
  end

  def create_full_invoice
    @sales_invoice.net = @quote.net
    @sales_invoice.vat = @quote.vat

    render :json => {
      :success => @sales_invoice.save && @sales_invoice.save_items(params[:items])
    }

    if params[:headersonly]
      @item = DesktopInvoiceItem.new({
        invoice_id:          @sales_invoice.id,
        description:         "Work carried out as per quotation ##{@quote.id}",
        quantity:            1,
        contract_id:         @sales_invoice.contract_id,
        acct_ref:            @sales_invoice.account_ref,
        unit_price:          @quote.net,
        net_amount:          @quote.net,
        vat:                 @quote.vat,
        last_user:           session[:username],
        maintenance_task_id: -1
      })
      @item.save
    else
      @quote.items.each do |item|
        DesktopInvoiceItem.new({
          invoice_id:          @sales_invoice.id,
          description:         item.description,
          quantity:            item.quantity,
          contract_id:         @sales_invoice.contract_id,
          acct_ref:            @sales_invoice.account_ref,
          unit_price:          item.unit_price,
          net_amount:          item.net,
          vat:                 item.vat,
          last_user:           session[:username],
          maintenance_task_id: -1
        }).save
      end
    end

    @quote.amount_invoiced = @quote.net
    @quote.is_invoiced     = true
    @quote.status          = "Invoiced"
    @quote.save

    AuditEvent.new({
      :event_type  => "quotes",
      :user        => session[:username],
      :date        => Time.now,
      :related_id  => @quote.id,
      :description => "Fully invoiced"
      }).save

    post_invoice_to_sage if params[:postinvoice] == "on"
  end

  def invoice_by_value(net, vat)
    @sales_invoice.net = @quote.net
    @sales_invoice.vat = @quote.vat

    render :json => {
      :success => @sales_invoice.save && @sales_invoice.save_items(params[:items])
    }

    if params[:headersonly]
      @item = DesktopInvoiceItem.new({
        invoice_id:          @sales_invoice.id,
        description:         "Work carried out as per quotation ##{@quote.id}",
        quantity:            1,
        contract_id:         @sales_invoice.contract_id,
        acct_ref:            @sales_invoice.account_ref,
        unit_price:          @quote.net,
        net_amount:          @quote.net,
        vat:                 @quote.vat,
        last_user:           session[:username],
        maintenance_task_id: -1
      })
      @item.save
    else
      @quote.items.each do |item|
        DesktopInvoiceItem.new({
          invoice_id:          @sales_invoice.id,
          description:         item.description,
          quantity:            item.quantity,
          contract_id:         @sales_invoice.contract_id,
          acct_ref:            @sales_invoice.account_ref,
          unit_price:          item.unit_price,
          net_amount:          item.net,
          vat:                 item.vat,
          last_user:           session[:username],
          maintenance_task_id: -1
        })
        item.save
      end
    end

    #@quote.amount_invoiced = @quote.value
    #@quote.status = "Invoiced"
    @quote.save

    AuditEvent.new({
      :event_type  => "quotes",
      :user        => session[:username],
      :date        => Time.now,
      :related_id  => @quote.id,
      :description => "Fully invoiced"
      }).save

    post_invoice_to_sage if params[:postinvoice] == "on"
  end

  def post_invoice_to_sage
    sage_interactor = SageInteractor.get_by_company_id(session[:company_id])

    next_invoice_number = sage_interactor.get_next_invoice_number

    @sales_invoice.number = next_invoice_number
    @sales_invoice.save

    customer = @quote.customer.desktop_customer

    # Post base invoice
    data = {
      "ACCOUNT_REF"       => @sales_invoice.account_ref,
      "INVOICE_DATE"      => Time.now.strftime("%m/%d/%Y"),
      "INVOICE_NUMBER"    => next_invoice_number,
      "INVOICE_TYPE_CODE" => "0",
      "ORDER_NUMBER"      => "#{@quote.id}".first(7), # sage only allows 7 digits :(
      "ITEMS_NET"         => @quote.net,
      "ITEMS_TAX"         => @quote.vat,
      "NOTES_1"           => "Work carried out as per quotation ##{@quote.id}",
      "NAME"              => customer.name,
      "CONTACT_NAME"      => customer.contact_name,
      "ADDRESS_1"         => customer.address_1,
      "ADDRESS_2"         => customer.address_2,
      "ADDRESS_3"         => customer.town,
      "ADDRESS_4"         => customer.region,
      "ADDRESS_5"         => customer.postcode
    }

    data["ITEMS_JSON"] = @quote.items.to_json unless params[:headersonly]

    puts sage_interactor.post_sales_invoice(data)
  end
end
