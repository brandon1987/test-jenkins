Rails.application.routes.draw do
  resources :users
  resources :stock_items
  ##############################################################################
  # ASSET REGISTER
  #
  resources :assets
  post 'assets/gridajaxdata'               => 'assets#gridajaxdata'
  post 'asset_types/add'                   => 'asset_types#add'
  get 'asset_types/delete'                 => 'asset_types#delete'
  get 'asset_status/add'                   => 'asset_status#add'
  get 'asset_status/delete'                => 'asset_status#delete'
 
 
  
  ##############################################################################
  # NOTIFICATIONS
  #
  get 'user_notifications/delete_notification_all' => 'user_notifications#delete_notification_all'
  get 'user_notifications/delete_notification' => 'user_notifications#delete_notification'
  get 'user_notifications/add_notification' => 'user_notifications#add_notification'

  ##############################################################################
  #  APPOINTMENTS
  #
  post  'appointments/get_list_json'
  patch 'appointments/update_mjob'
  patch 'appointments/update_contract'

  ##############################################################################
  #  ATTACHMENTS
  #
  get    'attachments/:section' => 'attachments#get'
  post   'attachments/:section' => 'attachments#create'
  delete 'attachments/:section' => 'attachments#destroy'

  ##############################################################################
  # BRANCH ADDRESSES
  get 'branch_addresses/for_web_customer/:id' => 'branch_addresses#for_web_customer'
  resources :branch_addresses

  patch  'company_preferences' => 'company_preferences#update'

  get 'customers/:id/get_address' => 'customers#get_address'
  post 'customers/import_from_desktop'
  resources :customers

  ##############################################################################
  #  QUOTES
  #
  post 'quotes/add_note'
  post 'quotes/gridajaxdata'               => 'quotes#gridajaxdata'
  get  'quotes/printable_list'             => 'quotes#get_printable_quote_list'
  resources :quotes
  get  'quotes/:id/get_quote_items'        => 'quotes#get_quote_items'
  get  'quotes/:id/history'                => 'quotes#history'
  post 'quotes/attach_to_contract'
  patch 'quote_statuses/:id/set_default'   => 'quote_statuses#set_default'
  resources :quote_statuses

  post 'mail/automailquote/:id' => 'mail#auto_mail_quote'
  post 'mail/mail_quote_from_post'
  post 'mail/send_invite_link'
  post 'mail/request_password_reset'

  resources :signed_url, only: :index

  post 'partial/partialrender'                    => 'partial#partialrender'

  get 'saved_grid_filters/savefilter'             => 'saved_grid_filters#savefilter'
  get 'saved_grid_filters/deletefilter'           => 'saved_grid_filters#deletefilter'



  post 'maintenance/gridajaxdata'                 => 'maintenance#gridajaxdata'
  get 'maintenance/downloadattachment'            => 'maintenance#downloadattachment'
  post 'maintenance/saveattachment'               => 'maintenance#saveattachment'
  post 'maintenance/deleteattachment'             => 'maintenance#deleteattachment'
  post 'maintenance/rendervisitxml'               => 'maintenance#rendervisitxml'
  get 'maintenance/loadsiteaddpopupcontents'      => 'maintenance#loadsiteaddpopupcontents'
  get 'maintenance/reloadlist'                    => 'maintenance#reloadlist'
  get 'maintenance/addattachmentfolder'           => 'maintenance#addattachmentfolder'
  get 'maintenance/deleteattachmentfolder'        => 'maintenance#deleteattachmentfolder'
  get 'maintenance/renameattachmentfolder'        => 'maintenance#renameattachmentfolder'
  resources :maintenance

  post 'maintenance_visit/gridajaxdata'           => 'maintenance_visit#gridajaxdata'
  get 'maintenance_visit/reloadlist'              => 'maintenance_visit#reloadlist'
  get 'maintenance_visit/loadvisit'               => 'maintenance_visit#loadvisit'
  get 'maintenance_visit/setvisitvalues'          => "maintenance_visit#setvisitvalues"
  get 'maintenance_visit/reassignvisit'           => "maintenance_visit#reassignvisit"
  get 'maintenance_visit/loadvisitlist'           => "maintenance_visit#loadvisitlist"
  get 'maintenancevisit/testreport'               => "maintenance_visit#testreport"
  resources :maintenance_visit

  get 'clientportal_hidden_columns/getsettings'   => "clientportal_hidden_columns#getsettings"
  get 'clientportal_hidden_columns/settingchange' => "clientportal_hidden_columns#settingchange"

  ##############################################################################
  #  TENDERS
  #
  post   'tenders/import'
  get    'tenders/:tender_id/grid_data'           => 'tenders#grid_data'
  patch  'tenders/:id/move/:target'               => 'tenders#move'
  post   'tenders/group'                          => 'tenders#create_group'
  delete 'tenders/group/:id'                      => 'tenders#destroy_group'
  patch  'tenders/group/:id/move/:target'         => 'tenders#move_group'
  resources :tenders
  patch  'tender_templates/:id/set_default'       => 'tender_templates#set_default'
  get    'tender_templates/:id/tree.json'         => 'tender_templates#get_tree'
  get    'tender_templates/:branch_id/grid_data'  => 'tender_templates#grid_data'
  post   'tender_templates/create_from_contract'
  resources :tender_templates
  post   'tender_template_items/import'
  post   'tender_template_items/create_group'
  resources :tender_template_items

  ##############################################################################
  #  CONTRACTS
  #
  get  'contracts/job_nos.json'                         => 'contracts#job_no_list'
  get  'contracts/:contract_id/tenders_tree(.:format)'  => 'tenders#get_tree'
  get  'contracts/:id/site_addresses'                   => 'contracts#get_site_addresses'
  get  'contracts/from_quote/:id'                       => 'contracts#new_contract_from_quote'
  post 'contracts/:id/import_site_addresses'            => 'contracts#import_site_addresses'
  post 'contracts/:id/add_all_eligible_subbies'         => "contracts#add_all_eligible_subbies"
  post 'contracts/:id/apply_subbie_template'            => 'contracts#apply_subbie_template'
  post 'contracts/gridajaxdata'                         => 'contracts#gridajaxdata'
  patch 'contracts/:id/defaults'                        => 'contracts#update_defaults'
  resources :contracts

  get 'welcome' => 'welcome#index'

  get  'login' => 'login#index'
  get  'logout' => 'login#logout'

  get  'accept_invite/:code' => 'login#process_invite'
  post 'login/check'
  post 'login/sign_up'

  ##############################################################################
  #  PLANNER
  #
  get  'planner' => 'planner#index'
  get  'planner/defaults' => 'planner#get_defaults'
  get  'planner/cost_code_list'
  get  'planner/contract_list'
  get  'planner/mjob_list'
  post 'planner/tenders_list'
  post 'planner/resources' => 'planner#get_resources'
  post 'planner/get_plant_code_details'
  post 'planner/load_event_details'
  post 'planner/load_plant_tran_details'
  post 'planner/save_appointment'
  post 'planner/save_new_appointment_contract'
  post 'planner/save_new_appointment_mjob'
  post 'planner/copy_appointment'
  post 'planner/delete_appointment'

  ##############################################################################
  #  PRODUCTS
  #
  get  'products/get_product_list_json'
  post 'products/get_product_details'
  post 'products/upload_stock_file'
  post 'products/import_from_sage'
  resources :products

  get 'termsandconditions' => 'public#termsandconditions'
  get 'privacy' => 'public#privacypolicy'
  get 'passwordreset' => 'public#passwordreset'
  get 'reset_password/:token' => 'public#reset_password'
  post 'reset_password' => 'public#service_password_reset'

  get    'reports'                       => 'reports#index'
  post   'reports'                       => 'reports#create'
  delete 'reports/:filename'             => 'reports#destroy'
  get    'reports/:filename'             => 'reports#show'
  post   'reports/set_default/:filename' => 'reports#set_default'

  ##############################################################################
  #  SALES INVOICES
  #
  post 'site_addresses/for_contract/:contract_id' => 'site_addresses#create_for_contract'
  resources :sales_invoices

  ##############################################################################
  #  SETTINGS
  #
  get 'settings' => 'settings#index'
  get 'settings/converttoclientportalsession' => 'settings#converttoclientportalsession'
  post 'settings/send_clientportal_password_email'
  post 'settings/set_clientportal_settings'
  post 'settings/set_clientportal_options'
  post 'settings/check_db_connection'
  post 'settings/save_db_connection'
  post 'settings/save_sage_connection'
  post 'settings/save_notification_opt_in'
  post 'settings/save_notification_priority'
  post 'settings/test_sage_connection'
  post 'settings/save_email_templates'
  post 'settings/update_password'
  post 'settings/clientportal_customer_gridajaxdata'    => 'settings#clientportal_customer_gridajaxdata'
  delete 'settings/revoke_invite/:id'                   => 'settings#revoke_invite'

  #Email address validator################################################
  get 'email_validate_model' => 'email_validate#validate_email'
  get 'email_validate_address' => 'email_validate#validate_email_arbitrary'
  ##############################################################################
  #  SUPPLIERS
  #
  post   'suppliers/templates'     => 'suppliers#create_template'
  delete 'suppliers/templates/:id' => 'suppliers#destroy_template'
  patch  'suppliers/templates/:id' => 'suppliers#update_template'
  get    'suppliers/template_members/:template_id' => 'suppliers#get_template_members'

  ##############################################################################
  #  MEMOS
  #
  resources :memos

  ##############################################################################
  #  SITE ADDRESSES
  #
  resources :site_addresses

  ##############################################################################
  #  WORKS
  #
  get 'works/grid_data_for_contract/:contract_id' => "works#grid_data_for_contract"
  resources :works

  resources :user_access_rights
  get 'permission_denied'                         => 'permission_denied#index'
  root "login#index"

  ##############################################################################
  #  ADMIN SUBSECTION
  #

  namespace :admin do
    get 'companies/:id/enable/:type' => 'companies#enable_permission'
    get 'companies/:id/disable/:type' => 'companies#disable_permission'
    resources :companies

    get  'users/:id/use'           => 'users#take_over'
    get  'users/revoke_invite/:id' => 'users#revoke_invite'
    post 'users/invite'
    resources :users

    resources :user_access_rights

    root "main#index"


  end

  namespace :clientportal do
    root "welcome#index"
    get "registration"
    get "register"
    get "login"
    get "logout"
    get "passwordreset"
    get "resetpassword"
    post "resetpassword_process"
    post "request_password_reset"
    get 'home' => "home#home" 

    get 'portal_maintenance_visit' => 'portal_maintenance_visit#index'
    post 'portal_maintenance_visit/gridajaxdata' => 'portal_maintenance_visit#gridajaxdata'

    get "portal_maintenance_task"  => 'portal_maintenance_task#index'
    post "portal_maintenance_task/gridajaxdata"  => 'portal_maintenance_task#gridajaxdata'
  end

  namespace :phoneportal do

    #get 'main' => "main#main"    
    match "main" => "main#main", as: :main, via: [:get, :post]

    get 'test' => "test#index"     
  end

  # catch all 404
  get '*path', to: redirect('/404.html')
end
