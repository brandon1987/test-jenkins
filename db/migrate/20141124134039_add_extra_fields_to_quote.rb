class AddExtraFieldsToQuote < ActiveRecord::Migration
  def change
    if self.table_exists?("quotes")
      add_column :quotes, :contact_name,  :string, default: ""
      add_column :quotes, :contact_email, :string, default: ""
      add_column :quotes, :contact_tel,   :string, default: ""
    end
  end
end
