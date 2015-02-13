require 'test_helper'
 
class CustomerTest < ActiveSupport::TestCase
  test "update to web customer mirrored on desktop" do
    new_name = Digest::MD5.hexdigest(Time.now.to_s)

    customer = Customer.where("link_id IS NOT NULL").first
    skip if customer.nil?
    customer.name = new_name
    customer.save

    desktop_customer = DesktopCustomer.find(customer.link_id)
    assert desktop_customer.name == new_name, "Expected '#{new_name}', got '#{desktop_customer.name}'"
  end

  test "update to web only customer not mirrored on desktop" do
    new_name = Digest::MD5.hexdigest(Time.now.to_s)

    customer = Customer.where(:link_id => nil).first
    skip if customer.nil?
    customer.name = new_name

    assert customer.save
  end

  test "shouldn't destroy customers related to quotes" do
    # find customer with quote
    related_quote = Quote.where("xid_customer != -1").first
    skip if related_quote.nil?

    customer = related_quote.customer

    # try to destroy it
    assert_raise(ActiveRecord::RecordNotDestroyed) do
      customer.destroy
    end
  end

  test "should create a customer" do
    assert Customer.new(
        name:         'TEST name',
        contact_name: 'TEST contact name',
        vat_reg_no:    'vrn',
        notes:        'TEST notes',
        address_1:    'TEST address 1',
        address_2:    'TEST address 2',
        town:         'TEST town',
        region:       'TEST region',
        postcode:     'TEST postcode',
        country_code: 'TT',
        tel:          'TEST tel',
        tel_2:        'TEST tel2',
        fax:          'TEST fax',
        email:        'TEST email',
        email2:       'TEST email2',
        email3:       'TEST email3',
        www:          'TEST www',
        xid_tax_rate: 0
      ).save
  end

  test "should update customer" do
    customer = customers(:TestCustomer1)
    assert customer.update_attributes(:name => 'New TEST name')
  end

  test "should send customer to cm50" do
    customer = customers(:TestCustomer1)
    assert_not customer.link_id

    customer.send_to_desktop

    assert customer.link_id, "Got #{customer.link_id}"
  end

  test "should destroy customer" do
    customer = customers(:TestCustomer2)
    customer.destroy
    assert_raise(ActiveRecord::RecordNotFound) {Customer.find(customer.id)}
  end

  test "new ref" do
    customer = customers(:TestCustomer1)
    customer.new_ref
    assert true
  end
end
