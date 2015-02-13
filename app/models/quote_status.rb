class QuoteStatus < ActiveRecord::Base
  scope :visible, -> { where(is_hidden: false) }

  validates :name, presence: true, uniqueness: true

  def default?
    is_default
  end

  def make_default
    QuoteStatus.where(is_default: true).update_all({is_default: false})

    self.is_default = true
    self.save
  end
end