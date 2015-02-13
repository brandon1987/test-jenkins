$(function() {
	configureQuotesGrid();

	$("#contract-quotes-grid button").click(openQuoteForInvoicing);
});

function configureQuotesGrid() {
	quotesGrid = $('#contract-quotes-grid').dataTable({
		"aoColumnDefs": [
			{ "sClass": "number-column",  "aTargets": [2,3,4] }
		],
		"bPaginate":     false,
		"bLengthChange": false,
		"bFilter":       true,
		"bSort":         false,
		"bInfo":         false,
		"bAutoWidth":    false,
		"language": {
			"emptyTable": "This contract has no related quotes"
		}
	});

	quotesGrid.enableSingleRowSelection();

	quotesGrid.totalsRow('2,3,4');
	quotesGrid.totalsRow('update');

	quotesGrid.onRowDoubleClicked(function(id){
		document.location = "/quotes/" + id;
	});
}

function openQuoteForInvoicing() {
	var id = $(this).parents("tr").attr("id").split("_").pop();
	document.location = "/quotes/" + id;
}