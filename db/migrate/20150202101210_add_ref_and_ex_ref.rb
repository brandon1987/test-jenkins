class AddRefAndExRef < ActiveRecord::Migration
  def change
    if self.table_exists?("quotes")
      add_column :quotes, :ref,    :string, default: "", limit: 32
      add_column :quotes, :ex_ref, :string, default: "", limit: 32
    end
  end
end
