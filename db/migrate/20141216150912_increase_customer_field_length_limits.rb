class IncreaseCustomerFieldLengthLimits < ActiveRecord::Migration
  def change
    change_column :customers, :name,         :string, :limit => nil
    change_column :customers, :contact_name, :string, :limit => nil
    change_column :customers, :vat_reg_no,   :string, :limit => nil
    change_column :customers, :address_1,    :string, :limit => nil
    change_column :customers, :address_2,    :string, :limit => nil
    change_column :customers, :town,         :string, :limit => nil
    change_column :customers, :region,       :string, :limit => nil
    change_column :customers, :postcode,     :string, :limit => nil
    change_column :customers, :country_code, :string, :limit => nil
    change_column :customers, :tel,          :string, :limit => nil
    change_column :customers, :tel_2,        :string, :limit => nil
    change_column :customers, :fax,          :string, :limit => nil
    change_column :customers, :email,        :string, :limit => nil
    change_column :customers, :email2,       :string, :limit => nil
    change_column :customers, :email3,       :string, :limit => nil
    change_column :customers, :www,          :string, :limit => nil

    remove_index(:customers, :name => 'link_id')
  end
end
