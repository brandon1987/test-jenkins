include FormatHelper

module GridData
  def GridData::get(model, grid_params, fields_array, column_id, joins, where, order,additional_fields_array)
    getGridData(model, grid_params, fields_array, column_id, joins, where, order,additional_fields_array)
  end

  def getGridData(databaseModel, gridparams, fieldsarray, stridcolumn, strjoins, strwhere, strorder, additional_fields_array, group="")
    # Set defaults
    gridparams[:columns]  ||= {}
    gridparams[:gridname] ||= SecureRandom::hex.first(8)

    #generate where statement from grid included values and custom where parameter
    filterparameters=[]
    gridparams[:columns].each do |column|
      if column[1]['search']['value'].is_json?
        specialparameter=JSON.parse(column[1]['search']['value'])
        case specialparameter["type"]
          when "filterdaterangedatetime"
            filterparameters<<fieldsarray[column[1]['data'].to_i].split("AS").first+">='"+date_format_mysql(specialparameter["start"])+"'" if specialparameter["start"]!=""
            filterparameters<<fieldsarray[column[1]['data'].to_i].split("AS").first+"<='"+date_format_mysql(specialparameter["end"]) +"'" if specialparameter["end"]!=""
          when "filterdaterangeepoch"
            filterparameters<<fieldsarray[column[1]['data'].to_i]+">='"+specialparameter["start"]+"'" if specialparameter["start"]!=""
            filterparameters<<fieldsarray[column[1]['data'].to_i]+"<='"+specialparameter["end"] +"'" if specialparameter["end"]!=""
          when "select"
            filterparameters<<fieldsarray[column[1]['data'].to_i]+specialparameter["value"] if specialparameter["value"]!=""
          when "mjobstatus"
            filterparameters<<"tblMaintenanceTask_Status"+specialparameter["value"] if specialparameter["value"]!=""
          when "mjobvisitstatus"
            filterparameters<<"tblMaintenanceRelated_IntegrationStatus"+specialparameter["value"] if specialparameter["value"]!=""
          when "contractcompleted"
            filterparameters<<"tblContractStatus"+specialparameter["value"] if specialparameter["value"]!=""

        end
      else
        filterparameters<<fieldsarray[column[1]['data'].to_i] +" LIKE '%"+ column[1]['search']['value'] + "%'" if column[1]['search']['value']!=""
      end
    end
    strwhere=" AND "<<strwhere if filterparameters.length!=0 && strwhere!=""
    strwheregrid=filterparameters.join(' AND ')+" "+strwhere

    #some defaults
    gridparams[:length]=DesktopMaintenanceTask.count if gridparams[:length]=="-1"
    data=[]

    selectfields=fieldsarray
    selectfields<<stridcolumn+" as _id"
    selectfields<<additional_fields_array if additional_fields_array
    if gridparams[:order]
      str_grid_order=fieldsarray[gridparams[:order]["0"][:column].to_i]+" "+ gridparams[:order]["0"][:dir]
    end
    strorder=str_grid_order if strorder!="" || strorder.nil?

    # Build queries
    base = databaseModel
            .order(strorder)
            .joins(strjoins)

    records = base
                .select(*selectfields)
                .limit(gridparams[:length])
                .offset(gridparams[:start])

    if strwheregrid.strip != ""
      records = records.where(strwheregrid)
      base = base.where(strwheregrid)
    end

    if group != ""
      records = records.group(group)
      base = base.group(group)
    end

    records.each do |record|
      rowdata={}
      customattributes={}
      record.attributes.each_with_index do |(fieldname,fieldvalue),index|

          rowdata.merge!({"#{index}"=>fieldvalue}) if fieldname!="_id" && !additional_fields_array.include?(fieldname)
          customattributes.merge!({"#{fieldname}"=>fieldvalue}) if fieldname!="_id" && additional_fields_array.include?(fieldname)

        if fieldname == "_id"
          rowdata.merge!({ "DT_RowId"=> "#{gridparams[:gridname]}_#{fieldvalue}" })
        end
      end
      rowdata.merge!({"DT_RowAttr"=>customattributes})
      data<<rowdata
    end

    #format data to be used by the grid
    returndata=GridLookupData.new
    returndata.draw = gridparams[:draw]
    returndata.recordsTotal    = databaseModel.count
    returndata.recordsFiltered = base.count
    returndata.data   = data
    returndata.error  = ""
    returndata.totals = []

    if !gridparams[:totalcolumns].nil?
      recordssum=databaseModel.order(strorder).joins(strjoins).select(*selectfields).where(strwheregrid) if strwheregrid.strip!=""
      recordssum=databaseModel.order(strorder).joins(strjoins).select(*selectfields) if strwheregrid.strip==""

      totalarray=[]
      totalfields=gridparams[:totalcolumns].split(",")
      selectfields.each_with_index do |column,index|
        if totalfields.include?(index.to_s)
          totalarray<<recordssum.sum(column) if column!=stridcolumn+" as _id"
        else
          totalarray<<"" if column!=stridcolumn+" as _id"
        end
      end
      returndata.totals=totalarray
    end

    return  returndata
  end
end


class GridDataFetcher
  attr_accessor :model, :grid_params, :fields_array, :str_id_column, :str_joins
  attr_accessor :str_where, :str_order, :additional_fields_array, :group

  def initialize
    @str_where = ""
    @additional_fields_array = []
  end

  def fetch
    return getGridData(
      @model,
      @grid_params,
      @fields_array,
      @str_id_column,
      @str_joins,
      @str_where,
      @str_order,
      @additional_fields_array,
      @group)
  end
end