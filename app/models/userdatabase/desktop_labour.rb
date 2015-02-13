class DesktopLabour < UserDatabaseRecord
  self.table_name = "tblhours"

  alias_attribute :id,                         :tblHoursId          
  alias_attribute :xid_contract,               :tblHoursXIDContract                  
  alias_attribute :xid_customer,               :tblHoursXIDCustomer                  
  alias_attribute :xid_cis,                    :tblHoursXIDCIS              
  alias_attribute :xid_job,                    :tblHoursXIDJob              
  alias_attribute :xid_pay,                    :tblHoursXIDPay              
  alias_attribute :xid_works,                  :tblHoursXIDWorks                
  alias_attribute :xid_audittrial,             :tblHoursXIDAuditTrial                    
  alias_attribute :xid_456,                    :tblHoursXID456              
  alias_attribute :xid_dayworks,               :tblHoursXIDDayworks                  
  alias_attribute :xid_si,                     :tblHoursXIDSI            
  alias_attribute :xid_costcode,               :tblHours_XIDCostCode                    
  alias_attribute :xid_tender,                 :tblHours_XIDTender                  
  alias_attribute :xid_timesheet,              :tblHours_XIDTimeSheet                    
  alias_attribute :xid_maintenancetask,        :tblHours_XIDMaintenanceTask                          
  alias_attribute :xid_visitorigin,            :tblHours_XIDvisitorigin                      
  alias_attribute :employee_id,                :tblHours_EmployeeId                  
  alias_attribute :payment_ref_id,             :tblHours_PaymentRefID                    


  alias_attribute :tender_item,                :tblHoursTenderItem                  
  alias_attribute :week_number,                :tblHoursWeekNumber                  
  alias_attribute :rate,                       :tblHoursRate            
  alias_attribute :charged,                    :tblHoursCharged              
  alias_attribute :dept,                       :tblHoursDept            
  alias_attribute :ncode,                      :tblHoursNCode            
  alias_attribute :taxcode,                    :tblHoursTaxCode              
  alias_attribute :vat,                        :tblHoursVat          
  alias_attribute :cis_tax_p,                  :tblHoursCISTaxP              
  alias_attribute :daywork_uplift,             :tblHoursDayWorkUplift                    
  alias_attribute :chargeout_total,            :tblHours_ChargeOutTotal                      
  alias_attribute :wip_backup,                 :tblHours_WIPBackup                  
  alias_attribute :costl,                      :tblHours_CostL              
  alias_attribute :allocate_wip,               :tblHours_AllocateWIP                    
  alias_attribute :maintenanc_emarkup,         :tblHours_MaintenanceMarkup                          
  alias_attribute :temphighest_charge_value,   :tblHours_TempHighestChargeValue                              
  alias_attribute :markup,                     :tblHours_Markup              
  alias_attribute :hours,                      :tblHours        
  alias_attribute :pay_factor,                 :tblHours_PayFactor                  
  alias_attribute :typex,                       :tblHoursType            
  
  alias_attribute :costcode,                   :tblHoursCostCode                
  alias_attribute :ex_ref,                     :tblHoursExRef            
  alias_attribute :tender_ref,                 :tblHoursTenderRef                
  alias_attribute :details,                    :tblHoursDetails              
  alias_attribute :rate_description,           :tblHours_RateDescription                        
  alias_attribute :lastuser,                   :tblHours_LastUser                
  
  alias_attribute :is_posted_payroll,          :tblHours_IsPostedPayRoll                        
  alias_attribute :no_payroll,                 :tblHours_NoPayroll                  
  alias_attribute :reconciled,                 :tblHoursReconciled                  
  
  alias_attribute :date_posted_payroll,        :tblHours_DatePostedPayRoll                          
  alias_attribute :wip_date,                   :tblHours_WIPDate                
  alias_attribute :date,                       :tblHoursDate            
  alias_attribute :datetimestamp,              :tblHours_DateTimeStamp                      
  

end
