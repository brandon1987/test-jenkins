$.ui.dialog.prototype._allowInteraction = function(e) {
	return !!$(e.target).closest('.ui-dialog, .ui-datepicker, .select2-drop').length;
};

function expandRow() {
	$(this).animate({height: 150}, 500);
	var newtotalsposition=$(".gridtotalscell").first().position().top+114;

	$(".gridtotalscell").addClass("js-expanded");
	$(".gridtotalscell.js-expanded").animate({top:newtotalsposition},500);
}

function shrinkRow() {
	$(this).animate({height: 27}, 500);
	var newtotalsposition=$(".gridtotalscell").first().position().top-114;
	$(".gridtotalscell.js-expanded").animate({top:newtotalsposition},500);
	$(".js-expanded").removeClass("js-expanded");
	// Horrible hack to get IE to stop breaking all of the rows.
	if (navigator.userAgent.match(/msie/i) || navigator.userAgent.match(/trident/i) ){
		$(this).parents("td").siblings().children().css("height", "27px");
	}
}

function StockList() {
	var list = this;
	this.products = [];

	this.initialize = function(callback) {
		list.products = PRODUCTS_LIST;

		if (typeof callback !== 'undefined') {
			callback.call();
		}

		$('#quote-items-grid').on('change', '.stock-code-input', function()
		{
			var newValue = $(this).val();
			if ( newValue === "" )
			{
				var selectedRow = $('#quote-items-grid').find('.row_selected');
				blankOutRow( $(selectedRow).children() );
			}
		});

		$('#quote-items-grid').on('focusin', '.stock-description-input', expandRow);
		$('#quote-items-grid').on('focusout', '.stock-description-input', shrinkRow);

	};

	this.applyFiltersToRow = function(row) {
		this.clearDropdowns();

		$selectElement = $(row).find('.stock-code-input');

		$selectElement.select2({
			data:{ results: this.products, text: 'textcombined' },
			formatSelection: productSelectionFormat,
			formatResult: productResultFormat,
			dropdownAutoWidth: false,
			initSelection: function(element, callback) {
				var data = {id: element.val(), text: element.val()};
				callback(data);
			}
		});

		$selectElement.on("change", function(e) {
			stockCodeChanged($(row), e.val);
		});
	};

	this.clearDropdowns = function()
	{
		if ( $('.stock-code-input, .stock-description-input').data('autocomplete') )
		{
			$('.stock-code-input, .stock-description-input')
				.autocomplete("destroy");
		}
	};
}

function productSelectionFormat(product) {
	return product.id;
}

function productResultFormat(product) {
	var html = '<div class="product-result">';
	html    += '<span>' + product.id   + '</span>';
	html    += '<span>' + product.text + '</span>';
	html    += '</div>'
	return html;
}

function stockCodeChanged(selectedRow, newCode) {
	var rowItems = $(selectedRow).children();

	if(newCode === "TEXT" || newCode === "M1") {
		setRowDescription( rowItems, "" );
		setRowQuantity( rowItems, 0 );
		setRowUnitPrice( rowItems, 0 );
		setRowDiscount( rowItems, 0 );
		recalculateAllRowValues();
	} else {
		$.ajax({
			type: 'POST',
			url: '/products/get_product_details',
			data: { code: newCode },
			success: function(response) {
				setRowDescription(rowItems, response.short_description);
				setRowLongDescription(rowItems, response.long_description);
				setRowUnitPrice(rowItems, response.unit_cost);
				recalculateAllRowValues();
			},
			dataType: 'json'
		});
	}
}