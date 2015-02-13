class AddRefAndExRef < ActiveRecord::Migration
  def change
    add_column :quotes, :ref,    :string, default: "", limit: 32
    add_column :quotes, :ex_ref, :string, default: "", limit: 32
  end
end
