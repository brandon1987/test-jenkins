class AddDefaultsToQuoteStatuses < ActiveRecord::Migration
  def change
    change_column_default :quote_statuses, :name,       ""
    change_column_default :quote_statuses, :is_default, false
    change_column_default :quote_statuses, :is_hidden,  false
  end
end
