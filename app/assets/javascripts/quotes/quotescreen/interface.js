$(document).ready(setUpPage);

function setUpPage() {
	$('#customer').select2();

	$("#notes-toggle").click(function() {
		var isOn = $(this).text().indexOf("more") !== -1;
		var newHeight = 50;

		if (isOn) {
			$(this).text("[less]");
			newHeight = 154;
		} else {
			$(this).text("[more]");
		}

		$("#quotenotes").animate({
			height: newHeight
		}, 500);
	});

	$('#quotedate').datepicker({
		dateFormat: "dd/mm/yy"
	});

	setUpCustomerDialog();
	$('#customer').change(onCustomerSelected);

	$("#add-quote-note-btn").click(addQuoteNote);

	$("#quote-save-button").click(saveQuote);
}

function setUpCustomerDialog(){
	$('#add-customer-dialog').dialog({
		width: 'auto',
		modal: 'true',
		autoOpen: false
	});

	$('#new-customer-save-button').click(addNewCustomer);
}

function onCustomerSelected() {	
	if ($('#customer').val() === "-2") {
		$('#add-customer-dialog').dialog('open');
	} else {
		updateAddressField();
	}
}

function addNewCustomer() {
	var data = $('#add-customer-form').serialize();

	$.ajax({
		type: 'POST',
		url: '/customers',
		data: data,
		success: function(newID) {
			var option = document.createElement("option");
			option.text = $('input[name="name"]').val();
			option.value = newID;

			$('#customer')[0].add(option,null);
			$('#customer').val( newID ).change();
			$('#add-customer-dialog').dialog('close');
		}
	});
}

function updateAddressField() {
	var customerID = $("#customer").val();

	if (customerID == -1) {
		$("#address").css("visibility", "hidden");
	} else {
		$.ajax({
			type: 'GET',
			url: '/customers/' + $("#customer").val() + '/get_address',
			success: function(response) {
				$('#address').val(response);
				$("#address").css("visibility", "visible");
			}
		});
	}
}

function addQuoteNote() {
	var text = $("#new-quote-note").val();

	$.ajax({
		type: "POST",
		url:  "/quotes/add_note",
		data: {
			quote_id: CURRENT_QUOTE,
			note:     text
		},
		success: function(response) {
			if (response.success) {
				$("#new-quote-note").val("");
				addNoteToList(response.timestamp, response.user, text);
			}
		}
	});
}

function addNoteToList(timestamp, user, text) {
	var noteDiv = $("<div/>").addClass("quote-note");

	var header = $("<h4/>").text(timestamp).appendTo(noteDiv);
	$("<span/>").text(" (" + user + ")").appendTo(header);

	$("<p/>").text(text).appendTo(noteDiv);

	noteDiv.prependTo("#quote-notes-list");
}
