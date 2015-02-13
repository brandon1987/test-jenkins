$(document).ready(onPageLoad);

function onPageLoad() {
	setUpAddressListGrid();

	$("#customers").addClass("menuActive");

	$('#delete-address-btn').click(checkQuoteDelete);

	$('#edit-address-btn').click(function(){
		var addressID = addressGrid.getSelectedRowID();
		if (addressID == -1) return;
		editAddress(addressID);
	});
}

function setUpAddressListGrid() {
	addressGrid = $('#addresses-grid').dataTable( {
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false,
		"sScrollY" : ($(".content-main").height()-100),
		"fnInitComplete": function() {
			$("#addresses-grid, .dataTables_scrollHeadInner table").animate({
				opacity: 1
			}, 500);
		}
	});
	
	addressGrid.columnFilters();
	addressGrid.enableMultiRowSelection();
	addressGrid.onRowDoubleClicked(editAddress);
	addressGrid.enableColumnToggling({'grid_name':'address_list_grid'});
}

function editAddress(id) {
	document.location = "/site_addresses/" + id;
}

function checkQuoteDelete() {
	if (!addressGrid.hasSelectedRows()) return;

	var button = $('#delete-addres-button');

	if(button.attr('data-confirm') === "1") {
		button.text('Delete');
		button.attr('data-confirm', 0 );
		button.removeClass('button-toggled-on');
		deleteSelectedQuote();
	} else {
		button.text('Confirm Delete');
		button.attr('data-confirm', 1 );
		button.addClass('button-toggled-on');
	}
}

function deleteSelectedQuote() {
	$.ajax({
		type: 'DELETE',
		url: '/site_addresses/' + addressGrid.getSelectedRowIds(),
		success: function() {
			addressGrid.deleteSelectedRows();
		}
	});
}

$(document).ready(function(){
	autoScroll();	
});