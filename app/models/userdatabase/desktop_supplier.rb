class DesktopSupplier < UserDatabaseRecord
  self.table_name = "tblsuppliers"

  alias_attribute :id,            :tblSupplier_Id
  alias_attribute :ref,           :tblSupplier_Ref
  alias_attribute :name,          :tblSupplier_Name
  alias_attribute :tax_treatment, :tblSupplier_TaxTreatment

  def can_be_subbie?
    tax_treatment && tax_treatment != ""
  end

  def DesktopSupplier.eligible_subbies
    DesktopSupplier.where("tblSupplier_TaxTreatment IS NOT NULL")
                   .where("tblSupplier_TaxTreatment != ''")
  end
end