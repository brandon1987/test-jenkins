class QuoteItem < ActiveRecord::Base
  belongs_to :quote, :foreign_key => :xid_quote

  def is_invoiced?
    quantity_invoiced == quantity
  end

  def part_invoiced?
    0 < quantity_invoiced && quantity_invoiced < quantity
  end
end