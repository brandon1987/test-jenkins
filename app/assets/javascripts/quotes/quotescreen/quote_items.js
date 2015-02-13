STOCK_CODE_INDEX   = 0;
DESCRIPTION_INDEX  = 1;
LDESCRIPTION_INDEX = 2;
QUANTITY_INDEX     = 3;
UNIT_PRICE_INDEX   = 4;
DISCOUNT_P_INDEX   = 5;
NET_PRICE_INDEX    = 6;
VAT_RATE_INDEX     = 7;
VAT_INDEX          = 8;
TOTAL_INDEX        = 9;

function getQuoteBodyJSON(){
	var body = [];

	if (quoteItemsTable.find(".dataTables_empty").length) {
		return "[]";
	}

	quoteItemsTable.find('tbody').find('tr').each(function() {
		var rowItems = $(this).children();

		var rowToSave = {
			code:                getCellValue(rowItems, STOCK_CODE_INDEX),
			description:         getCellValue(rowItems, DESCRIPTION_INDEX),
			long_description:    getCellValue(rowItems, LDESCRIPTION_INDEX),
			quantity:            getCellValue(rowItems, QUANTITY_INDEX),
			unit_price:          getCellValue(rowItems, UNIT_PRICE_INDEX),
			discount_percentage: getCellValue(rowItems, DISCOUNT_P_INDEX),
			net:                 getCellValue(rowItems, NET_PRICE_INDEX),
			vat_rate:            getCellValue(rowItems, VAT_RATE_INDEX),
			vat:                 getCellValue(rowItems, VAT_INDEX),
			total:               getCellValue(rowItems, TOTAL_INDEX)
		};

		body.push(rowToSave);
	});

	return JSON.stringify(body);
}

function recalculateAllRowValues()
{
	quoteItemsTable.find('tbody').find('tr').each(function()
	{
		var items = $(this).children();
		recalculateRowValues( items );
	});

	quoteItemsTable.totalsRow( 'update' );
}

function recalculateRowValues(items) {
	var quantity           = parseInt($(items.get(QUANTITY_INDEX)).find(".cleanbox-editable-cell").val()   || 0);
	var pricePerUnit       = parseFloat($(items.get(UNIT_PRICE_INDEX)).find(".cleanbox-editable-cell").val() || 0);
	var discountPercentage = parseFloat($(items.get(DISCOUNT_P_INDEX)).find(".cleanbox-editable-cell").val() || 0);
	var vatRate            = parseFloat($(items.get(VAT_RATE_INDEX)).text());

	var netPrice = pricePerUnit * quantity;
	netPrice = getNetPriceAfterDiscount(netPrice, discountPercentage);

	var vat = getVAT(netPrice, vatRate);

	var total = netPrice + vat;

	setRowNetPrice(items, netPrice);
	setRowVat(items, vat);
	setRowTotal(items, total);
}

function getNetPriceAfterDiscount( netPrice, discountPercentage )
{
	var percentageOfCostLeft = 100 - discountPercentage;
	percentageOfCostLeft /= 100;
	return percentageOfCostLeft * netPrice;
}

function getVAT( netPrice, vatRate )
{
	var vatMultiplier = vatRate / 100;
	return netPrice * vatMultiplier;
}

function deleteQuoteItems()
{
	quoteItemsTable.deleteSelectedRows();
	quoteItemsTable.totalsRow( 'update' );
}

function setCellToMoneyValue( cells, index, value )
{
	var cell = $(cells).get(index);
	value = formatStringToMoney( value );
	if ($(cell).has(".cleanbox-editable-cell").length) {
		$(cell).find(".cleanbox-editable-cell").val(value);
	} else {
		$(cell).text( value );
	}
}

function setRowUnitPrice( rowItems, unitPrice )
{
	setCellToMoneyValue( rowItems, UNIT_PRICE_INDEX, unitPrice );
}

function setRowDiscount(rowItems, discountPercentage) {
	var cell = $(rowItems).get(DISCOUNT_P_INDEX);
	$(cell).find("input").val( discountPercentage );
}

function setRowNetPrice( rowItems, netPrice )
{
	setCellToMoneyValue( rowItems, NET_PRICE_INDEX, netPrice );
}

function setRowVat( rowItems, vat )
{
	setCellToMoneyValue( rowItems, VAT_INDEX, vat );
}

function setRowStockCode( rowItems, code )
{
	var cell = $(rowItems).find(".stock-code-input");
	$(cell).val(code);
}

function setRowDescription( rowItems, description )
{
	var cell = $(rowItems).get(DESCRIPTION_INDEX);
	$(cell).children('textarea').val( description );
}

function setRowLongDescription(rowItems, description) {
	var cell = $(rowItems).get(LDESCRIPTION_INDEX);
	$(cell).children('textarea').val(description);
}

function setRowQuantity( rowItems, quantity )
{
	var cell = $(rowItems).get(QUANTITY_INDEX);
	$(cell).find("input").val(quantity);
}

function setRowTotal( rowItems, total )
{
	var totalCell = $(rowItems).get(TOTAL_INDEX);
	total = formatStringToMoney( total );
	$(totalCell).text( total );
}

function getCellValue(row, index) {
	var cell = $($(row).get(index));

	if (cell.find(".select2-chosen").length) {
		return cell.find(".select2-chosen").text();
	}

	if (cell.find("input").length) {
		return cell.find("input").val();
	}

	if (cell.find("textarea").length) {
		return cell.find("textarea").val();
	}

	return cell.text();
}

function blankOutRow( rowItems )
{
	setRowDescription( rowItems, "" );
	setRowQuantity( rowItems, 1 );
	setRowUnitPrice( rowItems, 0 );
	setRowDiscount( rowItems, 0 );
	setRowNetPrice( rowItems, 0 );
	recalculateRowValues( rowItems );
	quoteItemsTable.totalsRow( 'update' );
}

function formatStringToMoney( string )
{
	var number = parseFloat( string );
	number = number.toFixed( 2 );
	return number;
}

function updateQuoteItems(quoteRows) {
	quoteItemsTable.fnClearTable();

	for (var rowIndex = 0; rowIndex < quoteRows.length; rowIndex++) {
		var row = quoteRows[rowIndex];

		var index = quoteItemsTable.fnAddData( [
			row.code,
			row.description,
			row.long_description,
			row.quantity,
			row.unit_price,
			row.discount_percentage,
			"",
			row.vat_rate,
			"",
			""
			] );

		var newRow = quoteItemsTable.find('tbody').find('tr').get(index);
		$(newRow).attr('id', "quote_item_" + row.id);
		var cells = $(newRow).children();

		setRowQuantity( cells, row.quantity);
		setRowStockCode( cells, row.code );
		setRowDescription( cells, row.description );
		setRowLongDescription(cells, row.long_description);
		setRowUnitPrice( cells, row.unit_price );
		setRowDiscount(cells, row.discount_percentage);
		stockList.applyFiltersToRow( newRow );
	}

	recalculateAllRowValues();
	quoteItemsTable.totalsRow( 'update' );
	quoteItemsTable.recalculateTabOrder();
}

function setUpQuoteItemsGrid() {
	quoteItemsTable = $('#quote-items-grid').dataTable({
		"aoColumns": [
			{"sWidth": "10%"},
			{"sWidth": "25%"},
			{"sWidth": "6%"},
			{"sWidth": "9%"},
			{"sWidth": "10%"},
			{"sWidth": "10%"},
			{"sWidth": "10%"},
			{"sWidth": "10%"},
			{"sWidth": "10%"},
		],
		"aoColumnDefs": [
			{
				"sClass": "selectcell",
				"mRender": function (data, type, full) {
					return '<input class="stock-code-input"' + (CAN_EDIT ? "" : " disabled") + '>';
				},
				"aTargets": [ 0 ]
			}, {
				"sClass": "selectcell",
				"mRender": function (data, type, full) {
					var areaHTML = '<textarea class="stock-description-input" placeholder="Select a product or enter a description"'

					if (!CAN_EDIT) {
						areaHTML += " disabled"
					}

					areaHTML +='></textarea>';
					return areaHTML;
				},
				"aTargets": [DESCRIPTION_INDEX, LDESCRIPTION_INDEX]
			}, {
				"sClass": "number-column",
				"aTargets": [3, 4, 5, 6, 7, 8, 9]
			}
		],
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false,
		"language": {
			"emptyTable": 'Hit ADD ITEM to start filling out your quote'
		},
		"fnCreatedRow": function(nRow, aData, iDataIndex) {
			if (CAN_EDIT) {
				$(this).makeColsEditable('3,4,5', nRow, recalculateAllRowValues);
			}
		}
	});

	quoteItemsTable.totalsRow( '6,8,9' );
	quoteItemsTable.enableSingleRowSelection();
	quoteItemsTable.enableColumnToggling({'grid_name':'quote_items_grid'});

	$('.totals-row').find('td').click(function(){
		addNewQuoteItem();

		$('#quote-items-grid .row_selected').removeClass('row_selected');

		var lastRow = $('#quote-items-grid tbody').find('tr').not('totals-row').last();
		lastRow.addClass('row_selected');
		lastRow.find('td').first().find('input').focus();
		lastRow.find('td').first().find('input').autocomplete( "search", "" );
	});
}

function addNewQuoteItem() {
	var index = quoteItemsTable.fnAddData( [
		"",
		"",
		"",
		"0",
		"0.00",
		"0",
		"0.00",
		"20",
		"0.00",
		"0.00"
		] );

	stockList.applyFiltersToRow(quoteItemsTable.getRowByIndex(index));
	quoteItemsTable.totalsRow('update');
	quoteItemsTable.recalculateTabOrder();
}

/* Given a quote ID, request the quote body from the DB and populate the quote
 * items table with it.
 */
function loadQuoteItems(id) {
	$.ajax({
		type: 'GET',
		url: '/quotes/' + id + '/get_quote_items',
		success: function(response) {
			updateQuoteItems(response);
		},
		dataType: 'json'
	});
}
