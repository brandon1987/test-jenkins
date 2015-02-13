//= require ./partials/details
//= require ./partials/subcontractors
//= require ./partials/tenders
//= require ./partials/tender_templates
//= require ./partials/defaults
//= require ./partials/addresses
//= require ./partials/maintenance_options
//= require "../../../../vendor/assets/javascripts/jquery.nicefileinput.min.js"
//= require ./partials/streamupdates
//= require ./partials/attachments
//= require ./partials/quotes

$(function() {
	configureTabs();

	configureDatepickers();

	$('#status, #classification, #job_analysis, #project_manager, #pay_group').select2();

	$("#update-details-button").click(updateDetails);
});

function configureDatepickers(){
	$('#start_date, #to_be_completed, #date_completed, #stampdate').datepicker("setDate");
	$('#start_date, #to_be_completed, #date_completed, #stampdate').datepicker({ dateFormat: "dd/mm/yy" });
}

function configureTabs() {
	$("#contract-screen-tabs").tabs({
		activate:function(event,ui){
			switch($("#contract-screen-tabs").tabs("option","active")){
				case 2:
					try {
						tendersGrid.adjustGridAndToggleSize();
					} catch(e) {}
					break;
				case 6:
					try {
						taskAttachedFilesGrid.adjustGridAndToggleSize();
					} catch(e) {}
					break;
				case 7:
					try {
						quotesGrid.adjustGridAndToggleSize();
					} catch(e) {}
				default:
			}
		}
	});
}

function updateDetails() {
	var data = {};
	$("#contract-screen-tabs-details [name^=contract_details]").each(function() {
		data[$(this).attr("name")] = $(this).val();
	});

	if ($("#value_from_tenders")[0].checked) {
		data["contract_details[value_from_tenders]"] = 1;
	} else {
		data["contract_details[value_from_tenders]"] = 0;
	}

	$("#update-details-button").setButtonActive();
	$.ajax({
		type: "PATCH",
		url:  "/contracts/" + CONTRACT_ID,
		data: data,
		success: function(response) {
			if (response.success) {
				$("#update-details-button").setButtonSucceeded();
			} else {
				$("#update-details-button").setButtonFailed();
			}
		}
	});
}