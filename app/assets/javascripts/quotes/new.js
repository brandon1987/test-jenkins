//= require "./quotescreen/quote_items"
//= require "./quotescreen/stock_search"
//= require "./quotescreen/interface"
//= require "./quotescreen/save_quote"
//= require "./partials/print_and_mail"
//= require "./partials/create_order"
//= require "./partials/site_addresses"
//= require "./partials/branch_addresses"

function onPageLoad() {
	/* Define column indices  */
	ITEMS_GRID_NET_INDEX = 5;
	ITEMS_GRID_VAT_INDEX = 7;
	ITEMS_GRID_TOTAL_INDEX = 8;
	/* End index definition */

	setUpQuoteItemsGrid();

	stockList = new StockList();
	stockList.initialize(addNewQuoteItem);

	// Certain things must be disabled until the quote has been saved.
	$("#sales-order-conversion-button, #print-button, #email-button, #create-order-button").prop("disabled", true);

	$("#quote-screen-tabs").tabs({
			activate:function(event,ui){
				quoteItemsTable.totalsRow("update");
				quoteItemsTable.recalculateTabOrder();
			}
	});
}

$(document).ready(onPageLoad);

// If the window loses focus while the grid text areas are selected,
// resuming window focus and immediately focusing another element can cause
// and endless cycle of wobbles
$(window).blur(function() {
	$('textarea, input').blur();
});