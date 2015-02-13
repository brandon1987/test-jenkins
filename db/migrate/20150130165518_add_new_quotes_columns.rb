class AddNewQuotesColumns < ActiveRecord::Migration
  def change
    if self.table_exists?("quotes")
      add_column :quotes, :classification_id,  :integer, default: -1
      add_column :quotes, :analysis_id,        :integer, default: -1
      add_column :quotes, :project_manager_id, :integer, default: -1
    end
  end
end
