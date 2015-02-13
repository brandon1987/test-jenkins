class Customer < ActiveRecord::Base
  after_update :mirror_changes_in_desktop_customer
  validates :ref, presence: true, uniqueness: true, :allow_blank => true

  alias_attribute :is_linked, :link_id

  def destroy
    if Quote.where(:xid_customer => self.id).blank?
      super
    else
      raise ActiveRecord::RecordNotDestroyed, "Cannot delete a customer with quote associations"
    end
  end

  def desktop_customer
    if is_linked
      DesktopCustomer.find_by_ref(ref)
    end
  end

  def has_desktop_copy?
    is_linked
  end

  def send_to_desktop
    unless is_linked
      creation_params = {}

      attributes.to_a.each do |name, value|
        next if name == "id"
        next unless DesktopCustomer.method_defined?(name)
        creation_params[name] = value
      end

      creation_params[:default_ncode]  = 400
      creation_params[:account_status] = 0
      creation_params[:ref]            = new_ref

      dt_customer = DesktopCustomer.new(creation_params)

      if dt_customer.save
        update_attribute(:is_linked, dt_customer.id)
        save
      end
    end
  end

  # Generates a new reference code for the purposes of sending to CM50/Sage
  # These should be the first 8 letters of the company name, in caps, with a
  # number added until there's no duplication
  def new_ref
    ref = name.tr("' ","").upcase.first(8)
    base = ref

    refs = DesktopCustomer.pluck(:ref)

    counter = 1
    while refs.include?(ref)
      ref = "#{base}#{counter}"
      counter += 1
    end

    return ref
  end

  private
  def mirror_changes_in_desktop_customer
    remote_customer = DesktopCustomer.where(ref: ref).first

    if remote_customer
      update_params = {}

      attributes.to_a.each do |name, value|
        next if name == "id"
        next unless DesktopCustomer.method_defined?(name)
        update_params[name] = value
      end

      remote_customer.update_attributes(update_params)
    end
  end
end