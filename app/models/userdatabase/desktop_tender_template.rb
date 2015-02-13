class DesktopTenderTemplate < UserDatabaseRecord
  ##############################################################################
  # LEGACY STUFF
  self.table_name = "tbltendertemplate"

  before_create :set_defaults

  alias_attribute :id,   :tblTenderTemplate_ID
  alias_attribute :name, :tblTenderTemplate_TemplateName

  def set_defaults
    self.name ||= "Unnamed template"
  end
  # END LEGACY STUFF
  ##############################################################################

  # Given a contract ID, take that contract's tender structure and create a
  # template based on it.
  def DesktopTenderTemplate.create_from_contract(contract_id)
    template = DesktopTenderTemplate.new
    template.save

    @template_id = template.id

    tenders = DesktopTender.where(contract_id: contract_id)
                            .select(:id, :ref, :details, :is_group, :parent_group_id)

    self.tree_to_template(tenders, -1, -1)
  end

  def self.tree_to_template(tenders, root_id, new_root)
    puts "ROOT ID: #{root_id}"
    kids = tenders.select{ |x| x.parent_group_id == root_id }
    unless kids.blank?
      kids.each do |tender|
        puts "TENDER: #{tender}"
        puts "TENDER ID: #{tender.id}"
        template_item = DesktopTenderTemplateItem.new({
          :template_id => @template_id,
          :ref         => tender.ref.upcase,
          :details     => tender.details,
          :is_group    => tender.is_group,
          :group_id    => new_root
        })
        template_item.save

        self.tree_to_template(tenders, tender.id, template_item.id)
      end
    end
  end
end
