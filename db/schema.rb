# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150213123949) do

  create_table "asset_status", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status_name",       limit: 30, default: ""
    t.boolean  "hide_on_dropdowns",            default: false
  end

  create_table "asset_type", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type_name",  limit: 30, default: ""
  end

  create_table "assets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                limit: 60, default: ""
    t.string   "make",                limit: 30, default: ""
    t.string   "model",               limit: 30, default: ""
    t.string   "serial_no",           limit: 30, default: ""
    t.integer  "xid_site_address",               default: -1
    t.text     "locationdescription"
    t.string   "type",                limit: 30, default: ""
    t.text     "notes"
    t.date     "installation_date"
    t.date     "decomission_date"
    t.string   "status",              limit: 20, default: ""
  end

  create_table "audit_events", force: true do |t|
    t.string   "user"
    t.datetime "date"
    t.string   "event_type"
    t.string   "description"
    t.integer  "related_id"
  end

  create_table "clientportal_hiddencolumns", force: true do |t|
    t.integer "customer_id",                 default: -1
    t.string  "section",         limit: 30,  default: ""
    t.string  "column",          limit: 100, default: ""
    t.string  "column_selector", limit: 100, default: ""
  end

  create_table "companies", force: true do |t|
    t.string "display_name",              limit: 100
    t.string "login_name",                limit: 10
    t.string "last_schema_update",        limit: 19
    t.binary "connection_string"
    t.string "sage_integration_url"
    t.string "sage_integration_password"
  end

  create_table "company_preferences", force: true do |t|
    t.boolean "sage_payroll_connection",   default: false
    t.integer "default_tender_template",   default: -1
    t.boolean "quote_num_to_contract_num", default: false
    t.integer "quote_start_number",        default: 1
    t.string  "default_quote_template"
  end

  create_table "company_sessions", force: true do |t|
    t.integer  "xid_company"
    t.integer  "xid_user"
    t.string   "session_status",     limit: 50
    t.datetime "time"
    t.string   "last_schema_update", limit: 19
    t.binary   "connection_string"
  end

  create_table "customers", force: true do |t|
    t.integer "link_id"
    t.string  "ref",                                     default: ""
    t.string  "name"
    t.string  "contact_name"
    t.string  "vat_reg_no"
    t.string  "notes",                      limit: 2000
    t.string  "address_1"
    t.string  "address_2"
    t.string  "town"
    t.string  "region"
    t.string  "postcode"
    t.string  "country_code"
    t.string  "tel"
    t.string  "tel_2"
    t.string  "fax"
    t.string  "email"
    t.string  "email2"
    t.string  "email3"
    t.string  "www"
    t.integer "xid_tax_rate"
    t.string  "client_portal_password",                  default: ""
    t.boolean "is_portal_maintenance",                   default: false
    t.string  "clientportal_username",      limit: 50,   default: "0"
    t.string  "clientportal_email",                      default: ""
    t.boolean "is_portal_maintenancetasks",              default: false
  end

  create_table "invite_codes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id",  default: -1
    t.text     "invite_code"
    t.integer  "secret1",     default: 0
    t.integer  "secret2",     default: 0
    t.integer  "secret3",     default: 0
    t.string   "recipient",   default: ""
  end

  create_table "invites", force: true do |t|
    t.integer  "company_id"
    t.datetime "created"
    t.text     "invite_code"
    t.string   "recipient"
  end

  create_table "password_reset_requests", force: true do |t|
    t.text     "username"
    t.text     "token"
    t.datetime "created"
  end

  create_table "permissions", primary_key: "id_company", force: true do |t|
    t.integer "contracts"
    t.integer "maintenance"
    t.integer "visitlist"
    t.integer "purchaseorders"
    t.integer "purchaseinvoices"
    t.integer "quotes"
    t.integer "customers"
    t.integer "planner"
    t.integer "products"
    t.integer "reports"
  end

  create_table "quote_items", force: true do |t|
    t.integer "xid_quote"
    t.string  "code",                limit: 50,                          default: "TEXT"
    t.text    "description"
    t.text    "long_description"
    t.integer "quantity",                                                default: 1
    t.decimal "unit_price",                     precision: 30, scale: 2, default: 0.0
    t.decimal "discount_percentage",            precision: 30, scale: 2, default: 0.0
    t.decimal "net",                            precision: 30, scale: 2, default: 0.0
    t.decimal "vat_rate",                       precision: 30, scale: 2, default: 0.0
    t.decimal "vat",                            precision: 30, scale: 2, default: 0.0
    t.decimal "total",                          precision: 30, scale: 2, default: 0.0
    t.integer "quantity_invoiced",                                       default: 0
  end

  create_table "quote_notes", force: true do |t|
    t.integer  "quote_id",   default: -1
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user",       default: ""
  end

  create_table "quote_statuses", force: true do |t|
    t.string  "name",       default: ""
    t.boolean "is_default", default: false
    t.boolean "is_hidden",  default: false
  end

  create_table "quotes", force: true do |t|
    t.integer  "xid_customer"
    t.string   "status",             limit: 50
    t.integer  "xid_contract"
    t.datetime "date_created"
    t.datetime "date"
    t.text     "details"
    t.decimal  "net",                           precision: 30, scale: 2, default: 0.0
    t.decimal  "vat",                           precision: 30, scale: 2, default: 0.0
    t.decimal  "amount_invoiced",               precision: 10, scale: 0, default: 0
    t.boolean  "is_invoiced",                                            default: false
    t.integer  "address_id",                                             default: -1
    t.text     "instructions"
    t.integer  "xid_mjob",                                               default: -1
    t.string   "contact_name",                                           default: ""
    t.string   "contact_email",                                          default: ""
    t.string   "contact_tel",                                            default: ""
    t.integer  "number",                                                 default: -1
    t.integer  "branch_address_id",                                      default: -1
    t.integer  "classification_id",                                      default: -1
    t.integer  "analysis_id",                                            default: -1
    t.integer  "project_manager_id",                                     default: -1
    t.string   "ref",                limit: 32,                          default: ""
    t.string   "ex_ref",             limit: 32,                          default: ""
  end

  create_table "reports", id: false, force: true do |t|
    t.string   "filename",     limit: 19
    t.datetime "date_created"
    t.boolean  "is_default"
  end

  create_table "sales_orders", force: true do |t|
    t.integer  "xid_customer"
    t.integer  "xid_contract"
    t.datetime "date"
    t.decimal  "net",          precision: 30, scale: 2
    t.decimal  "vat",          precision: 30, scale: 2
    t.text     "description"
  end

  create_table "saved_grid_filters", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tablename",      limit: 30, default: ""
    t.string   "preset_name",    limit: 30, default: ""
    t.string   "column_title",   limit: 50, default: ""
    t.string   "filter_setting", limit: 30, default: ""
  end

  create_table "service_plan_link", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "xid_mjob"
    t.integer  "xid_service_plan"
    t.datetime "service_plan_start_date"
    t.datetime "next_service_date"
    t.datetime "last_service_date"
  end

  create_table "service_plans", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "xid_asset",                                                          default: 0
    t.string   "service_interval",               limit: 10,                          default: ""
    t.text     "service_description"
    t.text     "service_requirements"
    t.integer  "xid_customer",                                                       default: -1
    t.integer  "xid_contract",                                                       default: -1
    t.integer  "defaultmjobstatus",                                                  default: 1
    t.string   "xid_maintenance_forms",          limit: 30,                          default: ""
    t.text     "maintenance_form_field_mapping"
    t.decimal  "expected_duration",                         precision: 30, scale: 2, default: 0.0
  end

  create_table "stock_items", force: true do |t|
    t.string  "code",              limit: 64
    t.string  "short_description", limit: 64
    t.string  "long_description",  limit: 500
    t.decimal "unit_cost",                     precision: 30, scale: 2
    t.string  "unit_type",         limit: 10
  end

  add_index "stock_items", ["code"], name: "index_stock_items_on_code", unique: true, using: :btree

  create_table "user_access_rights", force: true do |t|
    t.integer "user_id",                                  default: 1
    t.boolean "constructionmanageradministration",        default: true
    t.boolean "databackup",                               default: true
    t.boolean "customers_add",                            default: true
    t.boolean "customers_edit",                           default: true
    t.boolean "customers_delete",                         default: true
    t.boolean "customers_applications_add",               default: true
    t.boolean "customers_applications_edit",              default: true
    t.boolean "customers_applications_delete",            default: true
    t.boolean "customers_applications_certify_post",      default: true
    t.boolean "customers_applications_salesinvoices",     default: true
    t.boolean "customers_certificates_post",              default: true
    t.boolean "customers_certificates_delete",            default: true
    t.boolean "customers_receipts_new",                   default: true
    t.boolean "customers_receipts_delete",                default: true
    t.boolean "customers_invoices_newinvoice",            default: true
    t.boolean "customers_invoices_newcredit",             default: true
    t.boolean "customers_invoices_edit",                  default: true
    t.boolean "customers_invoices_delete",                default: true
    t.boolean "customers_invoices_invoicing",             default: true
    t.boolean "customers_invoices_post",                  default: true
    t.boolean "suppliers_new",                            default: true
    t.boolean "suppliers_edit",                           default: true
    t.boolean "suppliers_delete",                         default: true
    t.boolean "suppliers_invoice_newinvoice",             default: true
    t.boolean "suppliers_invoice_newcredit",              default: true
    t.boolean "suppliers_invoice_edit",                   default: true
    t.boolean "suppliers_invoice_delete",                 default: true
    t.boolean "suppliers_invoice_post",                   default: true
    t.boolean "suppliers_products_in",                    default: true
    t.boolean "suppliers_products_out",                   default: true
    t.boolean "suppliers_products_edit",                  default: true
    t.boolean "suppliers_products_delete",                default: true
    t.boolean "suppliers_purchaseorders_new",             default: true
    t.boolean "suppliers_purchaseorders_edit",            default: true
    t.boolean "suppliers_purchaseorders_delete",          default: true
    t.boolean "suppliers_purchaseorders_order",           default: true
    t.boolean "suppliers_purchaseorders_goodsreceived",   default: true
    t.boolean "suppliers_purchaseorders_update",          default: true
    t.boolean "suppliers_purchaseorders_orderactivity",   default: true
    t.boolean "suppliers_purchaseorders_post",            default: true
    t.boolean "suppliers_purchaseorders_approval",        default: true
    t.boolean "subcontractors_applications_new",          default: true
    t.boolean "subcontractors_applications_edit",         default: true
    t.boolean "subcontractors_applications_delete",       default: true
    t.boolean "subcontractors_applications_certify_post", default: true
    t.boolean "subcontractors_certificates_new",          default: true
    t.boolean "subcontractors_certificates_batch",        default: true
    t.boolean "subcontractors_certificates_edit",         default: true
    t.boolean "subcontractors_certificates_delete",       default: true
    t.boolean "subcontractors_certificates_post",         default: true
    t.boolean "subcontractors_worksheets_new",            default: true
    t.boolean "subcontractors_worksheets_edit",           default: true
    t.boolean "subcontractors_worksheets_certify_post",   default: true
    t.boolean "subcontractors_worksheets_delete",         default: true
    t.boolean "subcontractors_payments_new",              default: true
    t.boolean "subcontractors_payments_edit",             default: true
    t.boolean "subcontractors_payments_delete",           default: true
    t.boolean "subcontractors_payments_post",             default: true
    t.boolean "subcontractors_returns_new",               default: true
    t.boolean "subcontractors_returns_edit",              default: true
    t.boolean "subcontractors_returns_delete",            default: true
    t.boolean "subcontractors_returns_esubmissions",      default: true
    t.boolean "subcontractors_pop_new",                   default: true
    t.boolean "subcontractors_pop_edit",                  default: true
    t.boolean "subcontractors_pop_delete",                default: true
    t.boolean "subcontractors_pop_application",           default: true
    t.boolean "subcontractors_pop_certify",               default: true
    t.boolean "subcontractors_pop_approval_post",         default: true
    t.boolean "contracts_new",                            default: true
    t.boolean "contracts_edit",                           default: true
    t.boolean "contracts_delete",                         default: true
    t.boolean "contracts_editnotes",                      default: true
    t.boolean "contracts_changestatus",                   default: true
    t.boolean "contracts_jobmanagement_activity",         default: true
    t.boolean "contracts_jobmanagement_wip",              default: true
    t.boolean "contracts_jobmanagement_adjustments",      default: true
    t.boolean "contracts_jobmanagement_valuation",        default: true
    t.boolean "labour_labourratesvisible",                default: true
    t.boolean "labour_delete",                            default: true
    t.boolean "labour_edit",                              default: true
    t.boolean "labour_timesheets_new",                    default: true
    t.boolean "labour_timesheets_edit",                   default: true
    t.boolean "labour_timesheets_delete",                 default: true
    t.boolean "labour_timesheets_post",                   default: true
    t.boolean "labour_employees_new",                     default: true
    t.boolean "labour_employees_edit",                    default: true
    t.boolean "labour_employees_delete",                  default: true
    t.boolean "labour_payrates_new",                      default: true
    t.boolean "labour_payrates_edit",                     default: true
    t.boolean "labour_payrates_delete",                   default: true
    t.boolean "labour_paygroups",                         default: true
    t.boolean "maintenance_add",                          default: true
    t.boolean "maintenance_edit",                         default: true
    t.boolean "maintenance_delete",                       default: true
    t.boolean "maintenance_jobprogress",                  default: true
    t.boolean "maintenance_invoice",                      default: true
    t.boolean "maintenance_repetitions",                  default: true
    t.boolean "maintenance_scheduleofrates",              default: true
    t.boolean "calendar_add",                             default: true
    t.boolean "calendar_edit",                            default: true
    t.boolean "calendar_delete",                          default: true
    t.boolean "plant_add",                                default: true
    t.boolean "plant_edit",                               default: true
    t.boolean "plant_delete",                             default: true
    t.boolean "plant_pop",                                default: true
    t.boolean "quotes_add",                               default: true
    t.boolean "quotes_edit",                              default: true
    t.boolean "quotes_delete",                            default: true
    t.boolean "quotes_order",                             default: true
    t.boolean "quotes_invoice",                           default: true
    t.boolean "quotes_email",                             default: true
  end

  create_table "user_mail_preferences", force: true do |t|
    t.integer "quotes_to_1"
    t.integer "quotes_to_2"
    t.integer "quotes_to_3"
    t.string  "quotes_cc",               limit: 500
    t.string  "quotes_bcc",              limit: 500
    t.text    "quotes_body"
    t.integer "sales_invoices_to_1"
    t.integer "sales_invoices_to_2"
    t.integer "sales_invoices_to_3"
    t.string  "sales_invoices_cc",       limit: 500
    t.string  "sales_invoices_bcc",      limit: 500
    t.text    "sales_invoices_body"
    t.integer "suppliers_pop_to_1"
    t.integer "suppliers_pop_to_2"
    t.integer "suppliers_pop_to_3"
    t.string  "suppliers_pop_cc",        limit: 500
    t.string  "suppliers_pop_bcc",       limit: 500
    t.text    "suppliers_pop_body"
    t.integer "subcontractors_pop_to_1"
    t.integer "subcontractors_pop_to_2"
    t.integer "subcontractors_pop_to_3"
    t.string  "subcontractors_pop_cc",   limit: 500
    t.string  "subcontractors_pop_bcc",  limit: 500
    t.text    "subcontractors_pop_body"
  end

  create_table "user_notification_opt_ins", force: true do |t|
    t.integer "user_id",                      default: -1
    t.string  "notification_type", limit: 50, default: ""
    t.integer "priority",                     default: 3
  end

  create_table "user_notifications", force: true do |t|
    t.integer  "user_id",                          default: -1
    t.string   "notification_type",     limit: 50, default: ""
    t.text     "notification_text"
    t.integer  "notification_priority",            default: 1
    t.text     "notification_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string  "username",          limit: 100
    t.integer "xid_company"
    t.string  "password_salt",     limit: 10
    t.string  "password_hash",     limit: 60
    t.binary  "connection_string"
    t.string  "hash_new"
    t.string  "salt_new"
    t.integer "priv_level"
  end

end
