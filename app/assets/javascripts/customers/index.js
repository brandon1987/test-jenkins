function configureCustomerGrid() {
	customerGrid = $('#customer-grid').dataTable( {
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": true,
		"bInfo": false,
		"bAutoWidth": true,
		"sScrollY" : ($(".content-main").height()-100),
		"bPaginate": true,
		"sPaginationType": "full_numbers",
		"bLengthChange": false,
		serverSide: true,
		ajax:{
			"url": "/customers.json",
			"data": { 'gridname': "customers_grid" },
			"error": function(lol) {
				swal("Error", "There was a problem loading the contract list.", "error");
			}
		}
	});
	customerGrid.columnFilters();
	customerGrid.enableSingleRowSelection();
	customerGrid.onRowDoubleClicked(function(id){
		loadCustomer(id);
	});
}

function editSelectedCustomer() {
	if (!customerGrid.hasSelectedRows()) return;
	document.location = "/customers/" + customerGrid.getSelectedRowID();
}

function loadCustomer(id) {
	document.location = "/customers/" + id
}

function checkCustomerDelete() {
	if (!customerGrid.hasSelectedRows()) return;

	var button = $('#delete-customer-button');

	if (button.attr('data-confirm') === "1") {
		button.text('Delete');
		button.attr('data-confirm', 0 );
		button.removeClass('button-toggled-on');
		deleteCustomer();
	} else {
		button.text('Confirm Delete');
		button.attr('data-confirm', 1 );
		button.addClass('button-toggled-on');
	}
}

function deleteCustomer() {
	$.ajax({
		type: 'DELETE',
		url: '/customers/' + customerGrid.getSelectedRowID(),
		success: function(response) {
			if (response.status == 0) {
				customerGrid.deleteSelectedRows();
			}
		}
	});
}

function bulkCustomerImport() {
	swal("Importing Customers", "Please wait.");
	$.ajax({
		type: 'POST',
		url: '/customers/import_from_desktop',
		success: function() {
			document.location = "/customers";
		}
	});
}

$(function() {
	configureCustomerGrid();
});

$(document).ready(function(){
	$("#customers").addClass("menuActive");
});

$(document).ready(function(){
	var WWWindex = $("th:contains('WWW')").parent().children().index($("th:contains('WWW')"));
	
	$("tr td:nth-child(" + (WWWindex + 1) +") a").each(function(){	
		var currentlink = $(this);
		var linkloc = currentlink.attr('href');
		var httpcheck = linkloc.substr(0,7);
		if(httpcheck!="http://"){
		currentlink.attr('href','http://'+linkloc);
	}
	});
});

$(document).ready(function(){
	autoScroll();	
});
