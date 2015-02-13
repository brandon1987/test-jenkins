$(function() {
	configureInvoiceDialog();

	$("#invoice-button").click(openInvoiceDialog);
	$("#full-invoice-button").click(fullInvoice);
	$("#invoice-by-quantities-button").click(invoiceByQuantities);
	$("#invoice-by-value-button").click(invoiceByValue);
});

function configureInvoiceDialog() {
	$("#invoice-dialog").dialog({
		width:     'auto',
		modal:     'true',
		autoOpen:  false,
		resizable: false
	});
}

function openInvoiceDialog() {
	$(".invoiceable-items").empty();

	quoteItemsTable.find('tbody').find('tr').each(function() {
		var rowItems = $(this).children();
		var description = getCellValue(rowItems, DESCRIPTION_INDEX);
		var quantity    = getCellValue(rowItems, QUANTITY_INDEX);

		var row = $("<tr>");
		$("<td/>").text(description).appendTo(row);

		$("<td/>")
			.append($("<input/>")
				.attr("type", "text")
				.attr("name", $(this).attr("id"))
				.addClass("js-invoiceable")
				.val(quantity))
			.appendTo(row);

		$("<td/>").text("/" + quantity).appendTo(row);

		row.appendTo($(".invoiceable-items"));
	});
	$("#invoice-dialog").dialog("open");
}

function fullInvoice() {
	var data = {};
	data["full"]  = true;
	if ($("#sage-post-checkbox").prop("checked")) {
		data["postinvoice"] =  "on";
	}

	if ($("#headers-only-checkbox").prop("checked")) {
		data["headersonly"] =  "on";
	}

	data["quote"] = CURRENT_QUOTE;

	$("#full-invoice-button").setButtonActive();
	$.ajax({
		type: "POST",
		url: "/sales_invoices",
		data: data,
		success: function(r) {
			$("#full-invoice-button").setButtonSucceeded();
			$("#create-order-button, #invoice-button").css("display", "none");
			$("#invoice-dialog").dialog("close");
			$("#status").val("Invoiced");
			$("#status").prop("disabled", true);
			invoiceSucceeded();
		},
		error: function() {
			$("#full-invoice-button").setButtonFailed();
		}
	});
}

function invoiceByQuantities() {
	var data = {};
	data["quote"] = CURRENT_QUOTE;
	data["items"] = {};
	if ($("#sage-post-checkbox").prop("checked")) {
		data["postinvoice"] =  "on";
	}

	if ($("#headers-only-checkbox").prop("checked")) {
		data["headersonly"] =  "on";
	}


	$(".js-invoiceable").each(function() {
		var name     = $(this).attr("name");
		var quantity = $(this).val();

		data["items"][name] = quantity;
	});

	$("#invoice-by-quantities-button").setButtonActive();
	$.ajax({
		type: "POST",
		url: "/sales_invoices",
		data: data,
		success: function(r) {
			console.log(r);
			$("#invoice-by-quantities-button").setButtonSucceeded();
		}
		,
		error: function() {
			$("#invoice-by-quantities-button").setButtonFailed();
		}
	});
}

function invoiceByValue() {
	var data = {};
	data["quote"] = CURRENT_QUOTE;
	data["value"] = $("#invoice-value").val();

	if ($("#sage-post-checkbox").prop("checked")) {
		data["postinvoice"] =  "on";
	}

	data["headersonly"] =  "on";

	$("#invoice-by-quantities-button").setButtonActive();
	$.ajax({
		type: "POST",
		url: "/sales_invoices",
		data: data,
		success: function(r) {
			$("#invoice-by-quantities-button").setButtonSucceeded();
		}
		,
		error: function() {
			$("#invoice-by-quantities-button").setButtonFailed();
		}
	});
}

function invoiceSucceeded() {
	swal("The quote has been invoiced.", "", "success");
}