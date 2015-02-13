//= require "./quotescreen/quote_items"
//= require "./quotescreen/stock_search"
//= require "./quotescreen/interface"
//= require "./quotescreen/save_quote"
//= require "./partials/print_and_mail"
//= require "./partials/create_order"
//= require "./partials/site_addresses"
//= require "./partials/branch_addresses"
//= require "./partials/invoice.js"

$(document).ready(onPageLoad);

function onPageLoad() {
	/* Define column indices  */
	ITEMS_GRID_NET_INDEX = 5;
	ITEMS_GRID_VAT_INDEX = 7;
	ITEMS_GRID_TOTAL_INDEX = 8;
	/* End index definition */

	setUpQuoteItemsGrid();

	if (CAN_EDIT) {
		stockList = new StockList();
		stockList.initialize();
	}

	loadQuoteItems(CURRENT_QUOTE);

	$("#quote-screen-tabs").tabs({
			activate:function(event,ui){
				quoteItemsTable.totalsRow("update");
			}
	});

	if (!CAN_EDIT) {
		$("input, button, textarea, select").prop("disabled", true);
		$("#back-button, #print-button").prop("disabled", false);
	}
}

// If the window loses focus while the grid text areas are selected,
// resuming window focus and immediately focusing another element can cause
// and endless cycle of wobbles
$(window).blur(function() {
	$('textarea, input').blur();
});
