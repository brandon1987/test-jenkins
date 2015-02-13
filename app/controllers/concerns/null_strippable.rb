module NullStrippable extend ActiveSupport::Concern
  def strip_nulls_from_record(record)
    record.attributes.each do |name, value|
      @site_address[name].gsub!("\u0000", "") if @site_address[name].is_a? String
    end
  end
end
