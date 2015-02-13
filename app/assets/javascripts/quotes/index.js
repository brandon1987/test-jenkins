//= require "./partials/bulk_email"

$(document).ready(onPageLoad);

function onPageLoad() {
	GRID_NAME='quote_list_grid'
	setUpQuoteListGrid();

	$("#customers").addClass("menuActive");

	$('#delete-quote-button').click(checkQuoteDelete);

	$('#edit-quote-button').click(function(){
		var quoteID = quotesGrid.getSelectedRowID();
		if (quoteID == -1) return;
		editQuote(quoteID);
	});

	$("#print-quote-button").click(openReportInViewer);

	bulkMailer = new BulkMailer();
}

function setUpQuoteListGrid() {
	ajaxUrl="/quotes/gridajaxdata";
	quotesGrid = $('#quotes-grid').dataTable( {
        "columnDefs": [
			{
				"sClass": "currency-column",
				"targets": [5,6,7]
			},
			{
				"sClass": "date-long filterdaterangedatetime",
				"targets": [3, 12, 14]
			}
		],
    	serverSide: true,
   		sServerMethod:'POST',
		ajax:{
		    "url": ajaxUrl,
		    "type": "POST",
		    "data": {'gridname':GRID_NAME}
		    },
		"deferLoading": 0,
		"bPaginate": true,
		"sPaginationType": "full_numbers",
		"bLengthChange": false,
		"bFilter": true,
		"bSort": true,
		"order": [[ 0, "desc" ]],		
		"bInfo": false,
		"bAutoWidth": true,
		"scrollX": true,
		"sScrollY" : ($(".content-main").height()-150),
		"fnInitComplete": function() {
			$("#quotes-grid, .dataTables_scrollHeadInner table").animate({
				opacity: 1
			}, 500);
		}
	});
	quotesGrid.onRowDoubleClicked(editQuote);
	quotesGrid.enableMultiRowSelection();
	quotesGrid.enableColumnFormatting();
	quotesGrid.enableColumnToggling({'grid_name':'quotes_list_grid'});
	quotesGrid.columnFilters();
	quotesGrid.totalsRow('5,6,7');
	quotesGrid.adjustGridAndToggleSize();
	quotesGrid.totalsRow('update');

}

function editQuote(id) {
	document.location = "/quotes/" + id;
}

function checkQuoteDelete() {
	if (!quotesGrid.hasSelectedRows()) return;

	var button = $('#delete-quote-button');

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
		url: '/quotes/' + quotesGrid.getSelectedRowIds(),
		success: function() {
			quotesGrid.deleteSelectedRows();
		}
	});
}

function openReportInViewer() {
	var report = $("#template-select-dialog select").val();
	
	var url = "http://reports.constructionmanager.net/api/view.php?";
	url += "companyID=" + COMPANY_ID;
	url += "&filename=" + DEFAULT_REPORT;
	url += "&QuoteID="  + quotesGrid.getSelectedRowID();

	$('#template-select-dialog').dialog('close');
	window.open( url );
}

$(document).ready(function(){
	autoScroll();	
});