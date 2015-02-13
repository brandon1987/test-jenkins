class AddRefToCustomersTable < ActiveRecord::Migration
  def change
    add_column :customers, :ref, :string, default: "", after: :link_id
  end
end
