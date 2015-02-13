class Quote < ActiveRecord::Base
  belongs_to :customer, :foreign_key => :xid_customer
  has_many :quote_item, :foreign_key => :xid_quote

  before_validation :recalculate_net_and_vat

  validates :net, presence: true
  validates :vat, presence: true

  def value
    net + vat
  end

  def self.total_value(array_of_quotes)
    array_of_quotes.map { |i| i.value }.sum.to_f
  end

  def attach_to_contract(new_contract_id)
    old_contract_id = xid_contract

    return if new_contract_id == old_contract_id

    update(:xid_contract => new_contract_id)
    update(:status       => "Ordered")

    # We want to remove the quote value from the old contract
    unless old_contract_id.nil?
      old_contract = DesktopContract.find(old_contract_id)
      old_contract.value -= net
      old_contract.value = 0 if old_contract.value < 0
      old_contract.save
    end

    # Now we want to increase the value of the new contract
    new_contract = DesktopContract.find(new_contract_id)
    new_contract.value += net
    new_contract.save

    if address_id != -1
      address = DesktopSiteAddress.find(address_id).attach_to_contract(new_contract_id)
    end
  end

  def has_contract?
    xid_contract
  end

  def update_items(items)
    QuoteItem.where(:xid_quote => id).destroy_all

    items.each do |item|
      item["xid_quote"] = id

      # If an empty string is passed for anything except the description,
      # we want to defer to the database defaults
      ["code", "quantity", "unit_price", "discount_percentage",
       "net", "vat_rate", "vat", "total"].each do |col|
        item.delete(col) if item[col] == ""
      end

      quote_item = QuoteItem.new(item)
      quote_item.save
    end
  end

  def is_invoiced?
    self.is_invoiced && amount_invoiced == net
  end

  def part_invoiced?
    self.is_invoiced && amount_invoiced < value && !self.is_invoiced?
  end

  def items
    QuoteItem.where(xid_quote: id)
  end

  def Quote.next_number
    number = CompanyPreferences.quote_start_number

    @numbers = Quote.pluck(:number)

    numeric_job_refs = DesktopContract.pluck(:job_no).select { |x| /\A[-+]?\d+\z/ === x }

    @numbers += numeric_job_refs

    while @numbers.include? number
      number += 1
    end

    return number
  end

  def recalculate_net_and_vat
    recalculate_net
    recalculate_vat
  end

  def recalculate_net
    self.net = items.pluck(:net).sum
  end

  def recalculate_vat
    self.vat = items.pluck(:vat).sum
  end
end