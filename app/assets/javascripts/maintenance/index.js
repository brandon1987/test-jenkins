//= require "./streamupdates"

function setUpMaintenanceListGrid() {

	GRID_NAME='maintenance_list_grid'
	maintenanceGrid = $('#mjob-table').dataTable( {
        "aoColumnDefs": [
            { "sClass": "datetime filterdaterangedatetime widecolumn ",  "aTargets": [8,9,10,11 ] },            
            { "sClass": "mjobcompleted regularwidth",  "aTargets": [ 5 ] }
   
        ],
    	serverSide: true,
   		sServerMethod:'POST',
		ajax:{
		    "url": "/maintenance/gridajaxdata",
		    "type": "POST",
		    "data": {'gridname':GRID_NAME}
		    },	
		"deferLoading": 0,		    
		"bPaginate": true,
		"sPaginationType": "full_numbers",
		"bLengthChange": false,
		"bFilter": true,
		"bSort": true,
		"order": [[ 1, "desc" ]],		
		"bInfo": false,
		"bAutoWidth": false,
		"scrollX": true,

		"sScrollY" : ($(".content-main").height()-160),
		"fnInitComplete": function() {
			$("#mjob-table, .dataTables_scrollHeadInner table").animate({
				opacity: 1
			}, 500);
		}     
	});
	maintenanceGrid.onRowDoubleClicked(editMaintenance);
	maintenanceGrid.enableMultiRowSelection();
	maintenanceGrid.enableColumnFormatting();
	maintenanceGrid.enableColumnToggling({'grid_name':GRID_NAME});	
	maintenanceGrid.columnFilters();
	maintenanceGrid.totalsRow('19');
	maintenanceGrid.adjustGridAndToggleSize();




	
}





function editMaintenance(id){
	document.location = "/maintenance/" + id;
}

function deleteMaintenance(){
	$.ajax({
		type: 'DELETE',
		url: '/maintenance/' + maintenanceGrid.getSelectedRowID(),
		success: function(response) {
			if (response.status == 0) {
				maintenanceGrid.deleteSelectedRows();
			}
		}
	});

}



function onPageLoad() {
	setUpMaintenanceListGrid();
 	$("#maintenancecompletefilter").select2();
}





$(document).ready(function(){
	onPageLoad();
	$("#maintenance").addClass("menuActive");
	$("#maintenancecompletefilter").change(function() {
		reloadGrid();
	});

	$('#edit-maintenance-button').click(function(){

		var maintenanceID =maintenanceGrid.getSelectedRowID();
		if (maintenanceID == -1) return;
		editMaintenance(maintenanceID);
	});

	$('#delete-maintenance-button').click(function(){
		swal({
		  title: "Are you sure?",
		  text: "You are about to delete the selected maintenance jobs, their visits, attached files and appointments. Are you sure you wish to continue?",
		  type: "warning",
		  showCancelButton: true,
		  confirmButtonColor: "#DD6B55",
		  confirmButtonText: "Yes, Proceed",
		  closeOnConfirm: false
		},
		function(){
		  deleteMaintenance();
		  websocket.emit('mjob_reload', COMPANY_ID);
		  swal("Deleted!", "The record has been deleted.", "success");
		});
		
	});
	
});

$(document).ready(function(){
	autoScroll();	
});