class User < Core
  belongs_to :company, :foreign_key => :xid_company

  after_create :create_permissions_entry

  def create_permissions_entry
    UserAccessRight.find_or_create_by(:user_id => id).save
  end
end
