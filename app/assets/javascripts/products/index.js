$(function() {
	configureProductGrid();

	$("#edit-stock-item-button").click(editSelectedProduct);
	$("#delete-stock-item-button").click(checkProductDelete);
});

function configureProductGrid() {
	productGrid = $('#product-grid').dataTable( {
		"aoColumns": [
			{ "sWidth": "13%", "bSortable": true }, // Code
			{ "sWidth": "35%", "bSortable": false, "sClass": "regular-width-col" }, // Short Description
			{ "sWidth": "41%", "bSortable": false, "sClass": "regular-width-col" }, // Long Description
			{ // Cost
				"sWidth": "5%",
				"sClass": "number-column",
				"bSortable": false
			},
			{ "sWidth": "6%", "bSortable": false } // Unit
		],
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": true,
		"bSortClasses": false,
		"bInfo": false,
		"bAutoWidth": false,
		"sScrollY" : ($(".content-main").height()-100),
		"fnInitComplete": function(oSettings, json) {
			//$(this).find('tbody tr').first().addClass("row_selected");
		}
	});
	productGrid.columnFilters();
	productGrid.enableSingleRowSelection();
	productGrid.onRowDoubleClicked(loadProduct);
}

function editSelectedProduct() {
	if (!productGrid.hasSelectedRows()) return;
	document.location = "/products/" + productGrid.getSelectedRowID();
}

function loadProduct(id) {
	document.location = "/products/" + id;
}

function checkProductDelete() {
	if (!productGrid.hasSelectedRows()) return;

	var button = $('#delete-stock-item-button');

	if (button.attr('data-confirm') === "1") {
		button.text('Delete');
		button.attr('data-confirm', 0 );
		button.removeClass('button-toggled-on');
		deleteProduct();
	} else {
		button.text('Confirm Delete');
		button.attr('data-confirm', 1 );
		button.addClass('button-toggled-on');
	}
}

function deleteProduct() {
	$.ajax({
		type: 'DELETE',
		url: '/products/' + productGrid.getSelectedRowIds(),
		success: function() {
			productGrid.deleteSelectedRows();
		}
	});
}

$(document).ready(function(){
	$("#products").addClass("menuActive");
});

$(document).ready(function(){
	autoScroll();
});