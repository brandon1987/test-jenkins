$(function() {
	configureContractListGrid();
});

function configureContractListGrid() {
	GRID_NAME='contracts_list_grid'

	contractListGrid = $('#contract-list-grid').dataTable( {
		"aoColumnDefs": [
			{
				"sWidth": "5%",
				"aTargets": [0]
			},
			{
				"sWidth": "8%",
				"sClass": "number-column",
				"aTargets": [3]
			},
            { "sWidth": "7%",  "aTargets": [5,6,7] },
            { "sClass": "filterdaterangedatetime date-long",  "aTargets": [5,6,7] },
            { "sClass": "contractcompleted", "aTargets":[8]}

        ],
    	serverSide: true,
   		sServerMethod:'POST',
		ajax:{
			"url": "/contracts/gridajaxdata",
			"type": "POST",
			"data": { 'gridname':GRID_NAME },
			"error": function(lol) {
				swal("Error", "There was a problem loading the contract list.", "error");
			}
		},
		"deferLoading": 0,
		"bPaginate": true,
		"sPaginationType": "full_numbers",
		"bLengthChange": false,
		"bFilter": true,
		"bSort": true,
		"order": [[ 0, "asc" ]],		
		"bInfo": false,
		"bAutoWidth": true,
		"scrollX": true,
		"sScrollY" : ($(".content-main").height()-150),
		"fnInitComplete": function() {
			$("#contract-list-grid, .dataTables_scrollHeadInner table").animate({
				opacity: 1
			}, 500);
		}
	});
	contractListGrid.onRowDoubleClicked(loadContract);
	contractListGrid.enableMultiRowSelection();
	contractListGrid.enableColumnFormatting();
	contractListGrid.enableColumnToggling({'grid_name':GRID_NAME});
	contractListGrid.columnFilters();

	contractListGrid.adjustGridAndToggleSize();
	contractListGrid.totalsRow('update');

}

function loadContract(id) {
	document.location = "/contracts/" + id;
}

$(document).ready(function(){
	$("#contracts").addClass("menuActive");
});

$(document).ready(function(){
	autoScroll();
});

$(function() {
	$("#edit-contract-button").click(function() { 
		var id = contractListGrid.getSelectedRowID();
		loadContract(id);
	})
});
