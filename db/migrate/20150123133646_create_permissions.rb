class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions, id: false do |t|
      t.integer :id_company, limit:11, :null => false
      t.integer :contracts, limit:11
      t.integer :maintenance, limit:11
      t.integer :visitlist, limit:11
      t.integer :purchaseorders, limit:11
      t.integer :purchaseinvoices, limit:11
      t.integer :quotes, limit:11
      t.integer :customers, limit:11
      t.integer :planner, limit:11
      t.integer :products, limit:11
      t.integer :reports, limit:11
    end
    execute "ALTER TABLE permissions ADD PRIMARY KEY (id_company)"
  end
end