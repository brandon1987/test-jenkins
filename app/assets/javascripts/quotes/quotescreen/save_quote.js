function saveQuote() {
	var data = {
		number:             $("#quote_number").val(),
		xid_customer:       $("#customer").val(),
		date:               $("#quotedate").val(),
		details:            $("#quotenotes").val(),
		body:               getQuoteBodyJSON(),
		status:             $("#status").val(),
		address_id:         $("#site_address").val(),
		instructions:       $("#instructions").val(),
		contact_name:       $("#contact_name").val(),
		contact_email:      $("#contact_email").val(),
		contact_tel:        $("#contact_tel").val(),
		branch_address_id:  $("#branch").val(),
		ref:                $("#ref").val(),
		ex_ref:             $("#ex_ref").val(),
		classification_id:  $("#classification_id").val(),
		analysis_id:        $("#analysis_id").val(),
		project_manager_id: $("#project_manager_id").val()
	};

	$("#quote-save-button").setButtonActive();

	if (typeof CURRENT_QUOTE !== 'undefined') {
		data.id = CURRENT_QUOTE;
		updateQuote(data);
	} else {
		addQuote(data);
	}
}

function addQuote(data) {
	$.ajax({
		type: 'POST',
		url:  '/quotes',
		data: data,
		success: function(newID) {
			$(".js-changed-input").removeClass("js-changed-input");
			document.location = "/quotes/" + newID;
		}
	});
}

function updateQuote(data) {
	$.ajax({
		type: 'PATCH',
		url:  '/quotes/' + data.id,
		data: data,
		success: function() {
			$(".js-changed-input").removeClass("js-changed-input");
			$("#quote-save-button").setButtonSucceeded();
			loadQuoteItems(CURRENT_QUOTE);
		}
	});
}