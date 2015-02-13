class Company < Core
  has_many :user, :foreign_key => :xid_company

  after_create :create_tenant_db
  after_create :create_permissions
  after_create :create_preferences

  def create_tenant_db
    Apartment::Tenant.create("conmag_#{id}")
  end

  def create_permissions
    permission = Permission.new
    permission.id_company = id
    permission.save
  end

  def create_preferences
    CompanyPreferences.new.save
  end
end
