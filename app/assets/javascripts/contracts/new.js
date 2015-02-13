//= require ./partials/details

$(function() {
	configureTabs();

	configureDatepickers();

	$('#status, #classification, #job_analysis, #project_manager, #pay_group').select2();

	$("#save-contract-button").click(saveNewContract);

	$("#jobno").change(checkJobNoUniqueness);
});

function configureDatepickers(){
	$('#start_date, #to_be_completed, #date_completed, #stampdate').datepicker("setDate");
	$('#start_date, #to_be_completed, #date_completed, #stampdate').datepicker({ dateFormat: "dd/mm/yy" });
}

function configureTabs() {
	$('#contract-screen-tabs').tabs({
		"disabled": [1, 2, 3, 4, 5, 6, 7]
	});
}

function saveNewContract() {
	var data = {};
	$("[name^=contract_details]").each(function() {
		data[$(this).attr("name")] = $(this).val();
	});

	data.quote_ids = $("[name=quote_ids]").val();

	$("#save-contract-button").setButtonActive();
	$.ajax({
		type: "POST",
		url:  "/contracts",
		data: data,
		success: function(response) {
			if (response.success) {
				document.location = "/contracts/" + response.new_contract;
			} else {
				$("#save-contract-button").setButtonFailed();
			}
		},
		error: function() {
			$("#save-contract-button").setButtonFailed();
		}
	});
}

function checkJobNoUniqueness() {
	var newRef = $("#jobno").val();
	$.get(
		"/contracts/job_nos.json",
		function(idList) {
			var valid = true;

			for (var i = 0; i < idList.length; i++) {
				var id = idList[i];
				if (id == newRef) {
					valid = false;
				}
			}

			if (valid) {
				$("#jobno").removeClass("invalid");
			} else {
				$("#jobno").addClass("invalid");
			}
		});
}