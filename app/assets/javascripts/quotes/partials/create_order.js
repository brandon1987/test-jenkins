$(document).ready(createOrderSetup);

function createOrderSetup() {
	prepareOrderCreationDialog();

	$("#create-order-button").click(openOrderCreationDialog);
	$("#order-attach-button").click(determineOrderType);
}

function prepareOrderCreationDialog() {
	$("#order-creation-dialog").dialog({
		width: '350px',
		autoOpen: false
	});

	$("#order-creation-dialog select").change(orderCreationSelectChanged);
}

function openOrderCreationDialog() {
	$("#order-creation-dialog").dialog('open');
}

function orderCreationSelectChanged() {
	var id = $(this).attr("id");

	var contract = $("#order-creation-dialog #contract_id").val();
	var mjob     = $("#order-creation-dialog #mjob_id").val();

	if (id == "contract_id") {
		$("#mjob_id").prop("disabled", contract > -1);
		$("#mjob_id").val("-1");
	} else {
		$("#contract_id").prop("disabled", mjob > -1);
		$("#contract_id").val("-1");
	}

	$("#order-attach-button").prop("disabled", contract == -1 && mjob == -1)
}

function determineOrderType() {
	var contract = $("#order-creation-dialog #contract_id").val();
	var mjob     = $("#order-creation-dialog #mjob_id").val();

	var quoteID;

	if(typeof quotesGrid !== "undefined") {
		quoteID = quotesGrid.getSelectedRowIDs();
	} else {
		quoteID = CURRENT_QUOTE;
	}

	if (contract > 0) {
		attachQuoteToContract(quoteID, contract);
	} else if (contract == 0) {
		attachQuoteToNewContract(quoteID);
	} else if (mjob > 0){
		attachQuoteToMJob(quoteID, mjob);
	} else if (mjob == 0) {
		attachQuoteToNewMJob(quoteID);
	}
}

function attachQuoteToContract(quoteID, contractID) {
	$("#order-attach-button").setButtonActive();

	var url = "/quotes/attach_to_contract";
	$.ajax({
		url: '/quotes/attach_to_contract',
		type: "POST",
		data: {
			id: quoteID,
			contract_id: contractID
		},
		success: function(r) {
			$("#order-attach-button").setButtonSucceeded();
			updateUIForContract(contractID);
			swal("Quote attached.", "", "success");
			$("#status").val("Ordered");
			$("#order-creation-dialog").dialog("close");
		}
	});
}

function updateUIForContract(contractID) {
	// We're on the main page
	if (typeof quotesGrid !== "undefined") {
		quotesGrid.getSelectedRow().each(function(){
			var row = $(this);
			row.children("td").last().html(
				'<a href="/contracts/' + contractID + '">Contract #' + contractID + '</a>'
			);
		});
	// We're on the edit page
	} else {
		$("#invoice-button").prop("disabled", false);
		$("#create-order-button").text("REASSIGN");
	}
}

function attachQuoteToNewContract(quoteIDs) {
	if (typeof quotesGrid !== "undefined") {
		var selectedIDs = quotesGrid.getSelectedRowIDs();
		document.location = "/contracts/from_quote/" + selectedIDs;
	// We're on the edit page
	} else {
		document.location = "/contracts/from_quote/" + CURRENT_QUOTE;
	}
}

function attachQuoteToMJob(quoteIDs, mjobID) {
	console.log("attaching quote to mjob " + mjobID);
}

function attachQuoteToNewMJob(quoteIDs) {
	console.log("attaching quote to new mjob");
}