module CustomersHelper
  def formatted_address(customer)
    address = ""

    address << [
      customer.address_1,
      customer.address_2,
      customer.town,
      customer.region,
      customer.country_code
    ].reject { |x| x.nil? or x == "" }.join("\n")

    address << "\n"

    address << [
      customer.tel,
      customer.tel_2
    ].reject { |x| x.nil? or x == "" }.join("\n")

    return address.chomp
  end
end