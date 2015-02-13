$(function() {
	// Subcontractor stuff
	configureSubcontractorGrid();
	configureSubbieDialogs();

	$("#edit-subcontractor-button").click(openEditSubbieDialog);
	$("#add-subcontractor-button").click(openAddSubbieDialog);
	$("#add-all-subbies-btn").click(addAllEligibleSubbies);
	$("#subbies-template-btn").click(openSubbieTemplates);

	// Template stuff
	$("#create-subbie-template-btn").click(createSubbieTemplate);
	$("#add-subbie-to-template-btn").click(addSubbieToTemplate);
	$("#remove-subbie-to-template-btn").click(removeSubbieFromTemplate);
	$("#save-subbie-template-btn").click(saveSubbieTemplate);
	$("#remove-subbie-template-btn").click(deleteSubbieTemplate);
	$("#apply-subbie-template-btn").click(applySubbieTemplate)
})

function configureSubcontractorGrid() {
	subcontractorGrid = $('#subcontractors-grid').dataTable( {
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false
	});
	subcontractorGrid.enableSingleRowSelection();
}

function configureSubbieDialogs() {
	$('#add-subbie-dialog, #edit-subbie-dialog, #subbie-template-dlg').dialog({
		width: 'auto',
		modal: 'true',
		autoOpen: false,
		resizable: false
	});

	$("#add_subbie_ac").change(newSubbieSelected);
	newSubbieSelected();

	$("#add-subbie-cancel-btn").click(closeAddSubbieDialog);
	$("#add-subbie-confirm-btn").click(addSubbieToContract);

	$("#edit-subbie-cancel-btn").click(function(){
		$("#edit-subbie-dialog").dialog("close");
	});
	$("#edit-subbie-confirm-btn").click(updateSubbieDetails);

	setUpTemplateDialog();
}

function newSubbieSelected() {
	var selected = $("#add_subbie_ac").val();

	for (i in ELIGIBLE_SUBBIES) {
		if (ELIGIBLE_SUBBIES[i].tblSupplier_Ref === selected) {
			$("#add_subbie_name").val(ELIGIBLE_SUBBIES[i].tblSupplier_Name);
		}
	}
}

function openAddSubbieDialog() {
	$('#add-subbie-dialog').dialog("open");
}

function closeAddSubbieDialog() {
	$('#add-subbie-dialog').dialog("close");
}

function addAllEligibleSubbies() {
	$("#add-all-subbies-btn").setButtonActive();

	$.ajax({
		type: "POST",
		url:  "/contracts/" + CONTRACT_ID + "/add_all_eligible_subbies",
		success: function(response) {
			$("#add-all-subbies-btn").setButtonCompleted(response.success);

			if (response.success) {
				ELIGIBLE_SUBBIES = [];

				$("#add-subcontractor-button").prop("disabled", true);
				$("#add-all-subbies-btn").prop("disabled", true);

				reloadSubbiesGrid();
			}
		}
	});
}

function addSubbieToContract() {
	$("#add-subbie-confirm-btn").setButtonActive();

	var data = {
		contract_id: CONTRACT_ID,
		work: {
			ref:                 $("#add_subbie_ac").val(),
			retention:           $("#add_subbie_ret_percentage").val(),
			ret_period:          $("#add_subbie_ret_period").val(),
			discount_percentage: $("#add_subbie_discount_percentage").val(),
			discount_method:     $("#add_subbie_discount_method").val()
		}
	};

	$.ajax({
		type: "POST",
		url:  "/works",
		data: data,
		success: function(response) {
			$("#add-subbie-confirm-btn").setButtonCompleted(response.success);

			if (response.success) {
				closeAddSubbieDialog();

				var ref = $("#add_subbie_ac").val();

				for (i in ELIGIBLE_SUBBIES) {
					if (ELIGIBLE_SUBBIES[i].tblSupplier_Ref === ref) {
						$("#add_subbie_name").val(ELIGIBLE_SUBBIES[i].tblSupplier_Name);
					}

					$("#add_subbie_ac [value=" + ref + "]").remove();

					ELIGIBLE_SUBBIES.splice(i, 1);

					if (ELIGIBLE_SUBBIES.length == 0) {
						$("#add-subcontractor-button").prop("disabled", true);
						$("#add-all-subbies-btn").prop("disabled", true);
					}
					break;
				}

				reloadSubbiesGrid();
			}
		}
	});
}

function reloadSubbiesGrid() {
	var url = '/works/grid_data_for_contract/' + CONTRACT_ID;
	subcontractorGrid.fnReloadAjax(url);
}

function openEditSubbieDialog() {
	var subbieID = subcontractorGrid.getSelectedRowID();

	if (subbieID === -1) return;

	$.ajax({
		type: "GET",
		url: "/works/" + subbieID,
		success: function(response) {
			$("#edit_subbie_ret_percentage").val(response.tblWorks_Retention);
			$("#edit_subbie_ret_period").val(response.tblWorks_RetPeriod);
			$("#edit_subbie_discount_percentage").val(response.tblWorks_Discount);
			$("#edit_subbie_discount_method").val(response.tblWorks_DiscountMethod);

			$("#edit-subbie-dialog").dialog("open");
		}
	});
}

function updateSubbieDetails() {
	var subbieID = subcontractorGrid.getSelectedRowID();

	var data = {
		work_id: subbieID,
		work: {
			retention:           $("#edit_subbie_ret_percentage").val(),
			ret_period:          $("#edit_subbie_ret_period").val(),
			discount_percentage: $("#edit_subbie_discount_percentage").val(),
			discount_method:     $("#edit_subbie_discount_method").val()
		}
	};

	$("#edit-subbie-confirm-btn").setButtonActive();

	$.ajax({
		type: "PATCH",
		url:  "/works/" + subbieID,
		data: data,
		success: function(response) {
			$("#edit-subbie-confirm-btn").setButtonCompleted(response.success);

			if (response.success) {
				$("#edit-subbie-dialog").dialog("close");
				reloadSubbiesGrid();
			}
		}
	});
}

function openPrintableSubbieList() {
	var url = '/works/grid_data_for_contract/' + CONTRACT_ID;
	window.open(url, '_blank');
}

function openSubbieTemplates() {
	$("#subbie-template-dlg").dialog("open");
	currentSubbiesTable.fnAdjustColumnSizing();
	subbiesTemplatesTable.fnAdjustColumnSizing();
	availableSubbiesTable.fnAdjustColumnSizing();
}

function setUpTemplateDialog() {
	subbiesTemplatesTable = $("#subbie-templates-list").dataTable({
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false,
		"sScrollY": "250"
	});
	subbiesTemplatesTable.enableSingleRowSelection();
	subbiesTemplatesTable.onRowSelected(subbieTemplateSelected);

	currentSubbiesTable = $("#current-subbies-list").dataTable({
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false,
		"sScrollY": "250",
		"language": {
			"emptyTable": 'No subcontractors assigned'
		}
	});

	availableSubbiesTable = $("#available-subbies-list").dataTable({
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false,
		"sScrollY": "250",
		"language": {
			"emptyTable": 'No subcontractors available'
		}
	});

	currentSubbiesTable.enableSingleRowSelection();
	availableSubbiesTable.enableSingleRowSelection();
}

function subbieTemplateSelected(id) {
	$.ajax({
		type:    "GET",
		url:     "/suppliers/template_members/" + id,
		success: function(response) {
			currentSubbiesTable.fnClearTable();
			availableSubbiesTable.fnClearTable();

			for (var i = 0; i < response.included.length; i++) {
				currentSubbiesTable.fnAddData([response.included[i]]);
			}

			for (var i = 0; i < response.not_included.length; i++) {
				availableSubbiesTable.fnAddData([response.not_included[i]]);
			}
		}
	});
}

function addSubbieToTemplate() {
	if (availableSubbiesTable.find(".row_selected").length == 0) return;

	var row = availableSubbiesTable.getSelectedRow();
	var ref = row.find("td").first().html();

	currentSubbiesTable.fnAddData([ref]);

	availableSubbiesTable.api()
		.row(row)
		.remove()
		.draw();
}

function removeSubbieFromTemplate() {
	if (currentSubbiesTable.find(".row_selected").length == 0) return;

	var row = currentSubbiesTable.getSelectedRow();
	var ref = row.find("td").first().html();

	availableSubbiesTable.fnAddData([ref]);

	currentSubbiesTable.api()
		.row(row)
		.remove()
		.draw();
}

function saveSubbieTemplate() {
	var templateID = subbiesTemplatesTable.getSelectedRowID();

	if (templateID == -1) return;
	
	var ids = [];

	currentSubbiesTable.find("tbody td:not(.dataTables_empty)").each(function() {
		ids.push($(this).html());
	});

	$("#save-subbie-template-btn").setButtonActive();

	$.ajax({
		type:    "PATCH",
		url:     "/suppliers/templates/" + templateID,
		data:    {subbie_refs: ids},
		success: function(response) {
			$("#save-subbie-template-btn").setButtonCompleted(response.success);
		}
	});
}

function deleteSubbieTemplate() {
	var templateID = subbiesTemplatesTable.getSelectedRowID();

	if (templateID == -1) return;

	$("#remove-subbie-template-btn").setButtonActive();

	$.ajax({
		type:    "DELETE",
		url:     "/suppliers/templates/" + templateID,
		success: function(response) {
			$("#remove-subbie-template-btn").setButtonCompleted(response.success);

			if (response.success) {
				subbiesTemplatesTable.api()
					.row(subbiesTemplatesTable.getSelectedRow())
					.remove()
					.draw();

				currentSubbiesTable.fnClearTable();
				availableSubbiesTable.fnClearTable();
			}
		}
	});
}

function createSubbieTemplate() {
	var newTemplateName = $("#new-subbie-template-name").val();

	$("#create-subbie-template-btn").setButtonActive();

	$.ajax({
		type:    "POST",
		url:     "/suppliers/templates",
		data:    { name: newTemplateName },
		success: function(response) {
			$("#create-subbie-template-btn").setButtonCompleted(response.success);

			if (response.success) {
				var index = subbiesTemplatesTable.fnAddData([newTemplateName]);

				$(subbiesTemplatesTable
					.find("tbody tr")
					.get(index))
					.attr("id", "desktop_subbie_template_" + response.new_id);
			}
		}
	});
}

function applySubbieTemplate() {
	var ids = [];

	currentSubbiesTable.find("tbody td:not(.dataTables_empty)").each(function() {
		ids.push($(this).html());
	});

	$("#apply-subbie-template-btn").setButtonActive();

	$.ajax({
		type:    "POST",
		url:     "/contracts/" + CONTRACT_ID + "/apply_subbie_template",
		data:    {subbie_refs: ids},
		success: function(response) {
			$("#apply-subbie-template-btn").setButtonCompleted(response.success);

			if (response.success) {
				reloadSubbiesGrid();
				console.log(response);
			}
		}
	});
}