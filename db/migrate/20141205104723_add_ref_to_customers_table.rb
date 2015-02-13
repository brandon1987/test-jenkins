class AddRefToCustomersTable < ActiveRecord::Migration
  def change
    if self.table_exists?("customers")
      add_column :customers, :ref, :string, default: "", after: :link_id
    end
  end
end
