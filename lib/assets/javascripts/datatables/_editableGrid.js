(function($) {
	/* EDITABLE COLUMNS */
	$.fn.makeColsEditable = function (cols, nRow, keyupCallback) {
		if (cols === "*") {
			cols = "td";
		} else {
			cols = cols.replace( /[^0-9,]/g, '' );
			cols = cols.replace( /,/g, '),td:eq(' );
			cols = 'td:eq(' + cols + ')';
		}

		var cells = $(nRow).children(cols);

		cells.each(function() {
			var cell = $(this);
			cell.css("padding", 0);
			var content = cell.html();
			var newCell = $("<input/>")
							.addClass("cleanbox-editable-cell")
							.keyup(keyupCallback);
			newCell.html(content);
			cell.html(newCell);
		});

		$(cols, nRow).keypress(function(e) {
			var keyCode = e.keyCode || e.which;

			if ($(this).hasClass("number-column")) {
				if (keyCode < 48 && keyCode !== 46) { // less than 0, not .
					return false;
				} if (keyCode > 57) { // greater than 9
					return false;
				}
			}

			if (keyCode !== 9) { // tab
				$(this).css('font-weight','bold');
				quoteItemsTable.totalsRow( 'update' );
			}
		});
	};
	/* END EDITABLE COLUMNS */

	$.fn.recalculateTabOrder = function() {
		$(this).unbind("keydown");
		$(this).on("keydown", "textarea, .cleanbox-editable-cell", function(e) {
			var keyCode = e.keyCode || e.which;

			if (keyCode == 9) {
				$(this).blur();
				e.preventDefault();

				var index = $(this).parents("td").index();
				next = $($(this).parents('tr').find("td").get(index + 1)).find("textarea, .cleanbox-editable-cell").first();

				next.focus();
			}
		});

		$(this).find('textarea, .cleanbox-editable-cell').each(function(e) {
			var $input = $(this);

			if (this.type !== "hidden") {
				$(this).focus(function(e){
					setTimeout( function(){
						selectText( $input[0] );
					}, 20);
				});
			}
		});

		var lastEditable = $(this).find('.cleanbox-editable-cell').last();
		lastEditable.unbind("keydown");
		lastEditable.keydown(function(e) {
			var keyCode = e.keyCode || e.which;

			if (keyCode == 9) {
				e.preventDefault();
				addNewQuoteItem();

				$('#quote-items-grid .row_selected').removeClass('row_selected');
				var lastRow = $('#quote-items-grid tbody').find('tr').not('totals-row').last();
				lastRow.addClass('row_selected');
				lastRow.find('td').find('input').first().focus();
			}
		});
	}
})(jQuery);
