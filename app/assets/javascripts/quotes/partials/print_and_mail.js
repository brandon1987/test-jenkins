function setUpPrintAndMailStuff() {
	$('#template-select-dialog, #template-select-dialog-for-email').dialog({
		width: 'auto',
		modal: 'true',
		autoOpen: false,
		resizable: false
	});

	$(".reports-list .img").click(function(){
		$(".reports-list .selected").removeClass("selected");
		$(this).addClass("selected");
	});

	$("#template-select-dialog .reports-box-back-button").click(function(){
		$('#template-select-dialog').dialog('close');
	});

	$("#template-select-dialog-for-email .reports-box-back-button").click(function(){
		$('#template-select-dialog-for-email').dialog('close');
	});

	$("#template-select-dialog .reports-list .img").dblclick(function(){
		$("#template-select-dialog #report-select-button").click();
	});

	$("#template-select-dialog-for-email .reports-list .img").dblclick(function(){
		$("#template-select-dialog-for-email #report-select-button").click();
	});

	$("#template-select-dialog #report-select-button").click(openReportInViewer);

	$(".mail-box-back-button").click(closeEmailBox);
	$("#mail-select-button").click(mailQuote);
}

function showReportTemplateSelection() {
	$("#template-select-dialog").dialog("open");
}

function showReportTemplateSelectionForEmail() {
	$("#template-select-dialog-for-email").dialog("open");
}

function openReportInViewer() {
	var report = $("#template-select-dialog select").val();
	
	//var url = "http://localhost/cm-services/reports/stimulsoft/api/view.php?";
	var url = "http://reports.constructionmanager.net/api/view.php?";
	url += "companyID=" + COMPANY_ID
	url += "&filename=" + report
	url += "&QuoteID="  + CURRENT_QUOTE

	$('#template-select-dialog').dialog('close');
	window.open( url );
}

function mailQuote() {
	$("#mail-select-button").setButtonActive();
	$.ajax({
		type: 'POST',
		url: '/mail/mail_quote_from_post',
		data: {
			id:       CURRENT_QUOTE,
			to:       $("#to_addresses").val(),
			cc:       $("#cc").val(),
			bcc:      $("#bcc").val(),
			body:     $("#mail_body").val(),
			template: $("#template-select-dialog-for-email [name=report_template]").val()
		},
		success: function(response) {
			$("#mail-select-button").setButtonSucceeded();
			closeEmailBox();
		}
	});
}

function closeEmailBox() {
	$("#template-select-dialog-for-email").dialog('close');
}

$(document).ready(setUpPrintAndMailStuff);