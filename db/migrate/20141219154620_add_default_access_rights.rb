class AddDefaultAccessRights < ActiveRecord::Migration
  def change
    change_column_default :user_access_rights, :user_id, true
    change_column_default :user_access_rights, :constructionmanageradministration, true
    change_column_default :user_access_rights, :databackup, true
    change_column_default :user_access_rights, :customers_add, true
    change_column_default :user_access_rights, :customers_edit, true
    change_column_default :user_access_rights, :customers_delete, true
    change_column_default :user_access_rights, :customers_applications_add, true
    change_column_default :user_access_rights, :customers_applications_edit, true
    change_column_default :user_access_rights, :customers_applications_delete, true
    change_column_default :user_access_rights, :customers_applications_certify_post, true
    change_column_default :user_access_rights, :customers_applications_salesinvoices, true
    change_column_default :user_access_rights, :customers_certificates_post, true
    change_column_default :user_access_rights, :customers_certificates_delete, true
    change_column_default :user_access_rights, :customers_receipts_new, true
    change_column_default :user_access_rights, :customers_receipts_delete, true
    change_column_default :user_access_rights, :customers_invoices_newinvoice, true
    change_column_default :user_access_rights, :customers_invoices_newcredit, true
    change_column_default :user_access_rights, :customers_invoices_edit, true
    change_column_default :user_access_rights, :customers_invoices_delete, true
    change_column_default :user_access_rights, :customers_invoices_invoicing, true
    change_column_default :user_access_rights, :customers_invoices_post, true
    change_column_default :user_access_rights, :suppliers_new, true
    change_column_default :user_access_rights, :suppliers_edit, true
    change_column_default :user_access_rights, :suppliers_delete, true
    change_column_default :user_access_rights, :suppliers_invoice_newinvoice, true
    change_column_default :user_access_rights, :suppliers_invoice_newcredit, true
    change_column_default :user_access_rights, :suppliers_invoice_edit, true
    change_column_default :user_access_rights, :suppliers_invoice_delete, true
    change_column_default :user_access_rights, :suppliers_invoice_post, true
    change_column_default :user_access_rights, :suppliers_products_in, true
    change_column_default :user_access_rights, :suppliers_products_out, true
    change_column_default :user_access_rights, :suppliers_products_edit, true
    change_column_default :user_access_rights, :suppliers_products_delete, true
    change_column_default :user_access_rights, :suppliers_purchaseorders_new, true
    change_column_default :user_access_rights, :suppliers_purchaseorders_edit, true
    change_column_default :user_access_rights, :suppliers_purchaseorders_delete, true
    change_column_default :user_access_rights, :suppliers_purchaseorders_order, true
    change_column_default :user_access_rights, :suppliers_purchaseorders_goodsreceived, true
    change_column_default :user_access_rights, :suppliers_purchaseorders_update, true
    change_column_default :user_access_rights, :suppliers_purchaseorders_orderactivity, true
    change_column_default :user_access_rights, :suppliers_purchaseorders_post, true
    change_column_default :user_access_rights, :suppliers_purchaseorders_approval, true
    change_column_default :user_access_rights, :subcontractors_applications_new, true
    change_column_default :user_access_rights, :subcontractors_applications_edit, true
    change_column_default :user_access_rights, :subcontractors_applications_delete, true
    change_column_default :user_access_rights, :subcontractors_applications_certify_post, true
    change_column_default :user_access_rights, :subcontractors_certificates_new, true
    change_column_default :user_access_rights, :subcontractors_certificates_batch, true
    change_column_default :user_access_rights, :subcontractors_certificates_edit, true
    change_column_default :user_access_rights, :subcontractors_certificates_delete, true
    change_column_default :user_access_rights, :subcontractors_certificates_post, true
    change_column_default :user_access_rights, :subcontractors_worksheets_new, true
    change_column_default :user_access_rights, :subcontractors_worksheets_edit, true
    change_column_default :user_access_rights, :subcontractors_worksheets_certify_post, true
    change_column_default :user_access_rights, :subcontractors_worksheets_delete, true
    change_column_default :user_access_rights, :subcontractors_payments_new, true
    change_column_default :user_access_rights, :subcontractors_payments_edit, true
    change_column_default :user_access_rights, :subcontractors_payments_delete, true
    change_column_default :user_access_rights, :subcontractors_payments_post, true
    change_column_default :user_access_rights, :subcontractors_returns_new, true
    change_column_default :user_access_rights, :subcontractors_returns_edit, true
    change_column_default :user_access_rights, :subcontractors_returns_delete, true
    change_column_default :user_access_rights, :subcontractors_returns_esubmissions, true
    change_column_default :user_access_rights, :subcontractors_pop_new, true
    change_column_default :user_access_rights, :subcontractors_pop_edit, true
    change_column_default :user_access_rights, :subcontractors_pop_delete, true
    change_column_default :user_access_rights, :subcontractors_pop_application, true
    change_column_default :user_access_rights, :subcontractors_pop_certify, true
    change_column_default :user_access_rights, :subcontractors_pop_approval_post, true
    change_column_default :user_access_rights, :contracts_new, true
    change_column_default :user_access_rights, :contracts_edit, true
    change_column_default :user_access_rights, :contracts_delete, true
    change_column_default :user_access_rights, :contracts_editnotes, true
    change_column_default :user_access_rights, :contracts_changestatus, true
    change_column_default :user_access_rights, :contracts_jobmanagement_activity, true
    change_column_default :user_access_rights, :contracts_jobmanagement_wip, true
    change_column_default :user_access_rights, :contracts_jobmanagement_adjustments, true
    change_column_default :user_access_rights, :contracts_jobmanagement_valuation, true
    change_column_default :user_access_rights, :labour_labourratesvisible, true
    change_column_default :user_access_rights, :labour_delete, true
    change_column_default :user_access_rights, :labour_edit, true
    change_column_default :user_access_rights, :labour_timesheets_new, true
    change_column_default :user_access_rights, :labour_timesheets_edit, true
    change_column_default :user_access_rights, :labour_timesheets_delete, true
    change_column_default :user_access_rights, :labour_timesheets_post, true
    change_column_default :user_access_rights, :labour_employees_new, true
    change_column_default :user_access_rights, :labour_employees_edit, true
    change_column_default :user_access_rights, :labour_employees_delete, true
    change_column_default :user_access_rights, :labour_payrates_new, true
    change_column_default :user_access_rights, :labour_payrates_edit, true
    change_column_default :user_access_rights, :labour_payrates_delete, true
    change_column_default :user_access_rights, :labour_paygroups, true
    change_column_default :user_access_rights, :maintenance_add, true
    change_column_default :user_access_rights, :maintenance_edit, true
    change_column_default :user_access_rights, :maintenance_delete, true
    change_column_default :user_access_rights, :maintenance_jobprogress, true
    change_column_default :user_access_rights, :maintenance_invoice, true
    change_column_default :user_access_rights, :maintenance_repetitions, true
    change_column_default :user_access_rights, :maintenance_scheduleofrates, true
    change_column_default :user_access_rights, :calendar_add, true
    change_column_default :user_access_rights, :calendar_edit, true
    change_column_default :user_access_rights, :calendar_delete, true
    change_column_default :user_access_rights, :plant_add, true
    change_column_default :user_access_rights, :plant_edit, true
    change_column_default :user_access_rights, :plant_delete, true
    change_column_default :user_access_rights, :plant_pop, true
  end
end
