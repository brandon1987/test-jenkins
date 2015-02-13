$(function() {
	configurMaintenanceOptionsGrid();
});

function configurMaintenanceOptionsGrid() {
	maintenanceOptionsGrid = $('#maintenance-options-grid').dataTable( {
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false
	});
	maintenanceOptionsGrid.enableSingleRowSelection();
}