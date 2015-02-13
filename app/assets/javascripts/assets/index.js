//= require "./type_dialog"
//= require "./status_dialog"



$(document).ready(function(){
	setUpAssetsListGrid();
	$("#new_asset_button").click(function(){
		newAsset();
	});

	$("#edit_asset_button").click(function(){
		var assetID =assetGrid.getSelectedRowID();
		if (assetID == -1) return;
		editAsset(assetID);
	});
});

function setUpAssetsListGrid() {

	GRID_NAME='assets_list_grid'
	assetGrid = $('#assets-table').dataTable( {
        "aoColumnDefs": [
            { "sClass": "datetime filterdaterangedatetime widecolumn ",  "aTargets": [7,8] }         
        ],
    	serverSide: true,
   		sServerMethod:'POST',
		ajax:{
		    "url": "/assets/gridajaxdata",
		    "type": "POST",
		    "data": {'gridname':GRID_NAME}
		    },	
		"deferLoading": 0,		    
		"bPaginate": true,
		"sPaginationType": "full_numbers",
		"bLengthChange": false,
		"bFilter": true,
		"bSort": true,
		"order": [[ 0, "asc" ]],		
		"bInfo": false,
		"bAutoWidth": false,
		"scrollX": true,

		"sScrollY" : ($(".content-main").height()-160),
		"fnInitComplete": function() {
			$("#assets-table, .dataTables_scrollHeadInner table").animate({
				opacity: 1
			}, 500);
		}     
	});
	assetGrid.onRowDoubleClicked(editAsset);
	assetGrid.enableMultiRowSelection();
	assetGrid.enableColumnFormatting();
	assetGrid.enableColumnToggling({'grid_name':GRID_NAME});	
	assetGrid.columnFilters();
	assetGrid.adjustGridAndToggleSize();




	
}

function editAsset(id){
	document.location = "/assets/" + id;
}
function newAsset(){
	document.location = "/assets/new"
}



