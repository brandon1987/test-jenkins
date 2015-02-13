TENDERS_REF_INDEX             = 0;
TENDERS_DETAILS_INDEX         = 1;
TENDERS_COSTBUDGET_INDEX      = 2;
TENDERS_COSTBUDGETALERT_INDEX = 3;
TENDERS_SALESBUDGET_INDEX     = 4;
TENDERS_TENDERTYPE_INDEX      = 5;
TENDERS_PCENTCOMPLETE_INDEX   = 6;
TENDERS_VALUECOMPLETE_INDEX   = 7;
TENDERS_AUTHORISED_INDEX      = 8;

var TENDER_FIELDS = [];
TENDER_FIELDS[TENDERS_REF_INDEX]             = "ref";
TENDER_FIELDS[TENDERS_DETAILS_INDEX]         = "details";
TENDER_FIELDS[TENDERS_COSTBUDGET_INDEX]      = "cost_budget";
TENDER_FIELDS[TENDERS_COSTBUDGETALERT_INDEX] = "cost_budget_alert";
TENDER_FIELDS[TENDERS_SALESBUDGET_INDEX]     = "sales_budget";
TENDER_FIELDS[TENDERS_TENDERTYPE_INDEX]      = "tender_type";
TENDER_FIELDS[TENDERS_PCENTCOMPLETE_INDEX]   = "percent_complete";
TENDER_FIELDS[TENDERS_VALUECOMPLETE_INDEX]   = "value_complete";
TENDER_FIELDS[TENDERS_AUTHORISED_INDEX]      = "authorised";

TEMPLATES_REF_INDEX = 0;
TEMPLATES_DETAILS_INDEX = 1;
TEMPLATES_AMOUNT_INDEX = 2;

var TEMPLATE_FIELDS = [];
TEMPLATE_FIELDS[TEMPLATES_REF_INDEX] = "ref";
TEMPLATE_FIELDS[TEMPLATES_DETAILS_INDEX] = "details";
TEMPLATE_FIELDS[TEMPLATES_AMOUNT_INDEX] = "amount";

$(function() {
	reloadTendersTree();
	setUpTendersGrid();
	setUpTendersDialog();

	// Tenders groups
	$("#tenders-add-group-btn").click(addTendersGroupPrompt);
	$("#edit-tenders-group-btn").click(promptForNewTenderGroupName);
	$("#delete-tender-group-btn").click(confirmTenderGroupDelete);
	$("#move-tender-group-btn").click(tryTenderGroupMove);
	$("#cancel-move-tender-group-btn").click(endTenderGroupMove);

	// Tenders
	$("#add-tender-btn").click(promptForTenderName);
	$("#move-tender-btn").click(tryTenderMove);
	$("#delete-tender-btn").click(confirmTenderDelete);

	$('#tenders-import-button').click(function() {
		$('#tenders-import-dialog').dialog( 'open' );
	});

	watchForTenderChanges();
	watchForTenderTemplateChanges();
});

function watchForTenderChanges() {
	$("#tenders-grid").on("change", "input, select", function() {
		var input = $(this);
		var tenderID = input.parents("tr").attr("id").split("_").pop();
		var field = TENDER_FIELDS[input.parents("td").index()];

		var newVal;
		if (input.is("input") && input.attr("type") === "checkbox") {
			newVal = input.is(":checked") ? 1 : 0;
		} else {
			newVal = input.val();
		}

		updateTenderValue(tenderID, field, newVal);
	});
}

function updateTenderValue(tenderID, field, value) {
	var data = {};
	data[field] = value;

	$.ajax({
		type: "PATCH",
		url:  "/tenders/" + tenderID,
		data: data
	});
}

function watchForTenderTemplateChanges() {
	$("#tender-template-values-table").on("change", "input, select", function() {
		var input = $(this);
		var tenderID = input.parents("tr").attr("id").split("_").pop();
		var field = TEMPLATE_FIELDS[input.parents("td").index()];

		var newVal;
		if (input.is("input") && input.attr("type") === "checkbox") {
			newVal = input.is(":checked") ? 1 : 0;
		} else {
			newVal = input.val();
		}

		updateTenderTemplateValue(tenderID, field, newVal);
	});
}

function updateTenderTemplateValue(tenderID, field, value) {
	var data = {};
	data[field] = value;

	$.ajax({
		type: "PATCH",
		url:  "/tender_template_items/" + tenderID,
		data: data
	});
}

function setUpTendersTree() {
	$('#tenders-tree')
		.on('select_node.jstree', function (node, selected, event) {
			var id = selected.node.id.split("_").pop();
			loadTendersData(id);

			var nestLevel = $("#" + $("#tenders-tree").jstree("get_selected")[0])
										.parents("li").length;
			$("#tenders-add-group-btn").prop("disabled", nestLevel === 2);

			var moveButton = $("#move-tender-group-btn");
			if (moveButton.text() === "Confirm") {
				moveButton.prop("disabled", selected.node.id === moveButton.attr("data-branch"));
			}
		})
		.jstree();
}

function setUpTendersGrid() {
	tendersGrid = $('#tenders-grid').dataTable( {
		//"sScrollY": "200px",
		"bScrollCollapse": true,
		"bPaginate": false,
		"columnDefs": [
			{
				"sClass": "selectcell",
				"render": function (data, type, row) {
					return "<input class=\"cleanbox-editable-cell\" value=\"" + data + "\">";
				},
				"targets": [1, 2, 4, 6, 7]
			},
			{
				"sClass": "selectcell",
				"render": function (data, type, row) {
					return getTenderTypeDropdown(data, type, row)
				},
				"targets": 5
			},
			{
				"sClass": "selectcell",
				"render": function (data, type, row) {
					return getTenderCheckbox(data, type, row)
				},
				"targets": [3, 8]
			}
		],
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false,
	});

	tendersGrid.enableSingleRowSelection();
}

function getTenderTypeDropdown(data, type, row) {
	var select = "<select>";
	select += "<option value=1"
	if (data == 1) { select += " selected"; }
	select += ">Contract Claim</options>";
	select += "<option value=2"
	if (data == 2) { select += " selected"; }
	select += ">Dayworks</option>";
	select += "<option value=3"
	if (data == 3) { select += " selected"; }
	select += ">Variations</option>";
	select += "</select>";
	return select;
}

function getTenderCheckbox(data, type, row) {
	var checkbox = "<input type=\"checkbox\" ";
	if (data == 1) {
		checkbox += "checked";
	}
	checkbox += ">";
	return checkbox;
}

function loadTendersData(tenderID) {
	var newURL = "/tenders/" + tenderID + "/grid_data";
	tendersGrid.fnReloadAjax(newURL);
}

function reloadTendersTree() {
	$('#tenders-tree').jstree("destroy");

	$.ajax({
		type: "GET",
		url: "/contracts/" + CONTRACT_ID + "/tenders_tree.json",
		success: function(data) {
			$('#tenders-tree').jstree({ 'core' : {
				'data' : data
			}});

			setUpTendersTree();
		}
	});
}

function addTendersGroupPrompt() {
	inputDialog({
			dialoglabel: "",
			inputlabels: ["Group name"],
		},
		function done(isConfirmed, formData){
			if(isConfirmed) {
				addTenderGroup(formData);
			}
		}
	);
}

function addTenderGroup(formData) {
	var groupName = formData[0]["value"];

	var parentID = -1;

	if ($("#tenders-tree").jstree("get_selected").length) {
		var parentID = $("#tenders-tree").jstree("get_selected")[0];
		parentID = parentID.split("_").pop();
	}

	var nestLevel = $("#" + $("#tenders-tree").jstree("get_selected")[0])
										.parents("li").length + 2;

	$.ajax({
		type: "POST",
		url:  "/tenders/group",
		data: {
			parent:      parentID,
			name:        groupName,
			contract_id: CONTRACT_ID,
			level:       nestLevel
		},
		success: function(response) {
			reloadTendersTree();
		}
	});
}

function confirmTenderGroupDelete() {
	if (!$("#tenders-tree").jstree("get_selected").length) return;

	swal({
		title: "Delete Group",
		text: "Are you sure you wish to delete the group and all of its contents?",
		type: "warning",
		showCancelButton: true,
		confirmButtonColor: "#DD6B55",
		confirmButtonText: "Yes, delete it!",
		closeOnConfirm: true
	},
	deleteSelectedTenderGroup);
}

function deleteSelectedTenderGroup() {
	if ($("#tenders-tree").jstree("get_selected").length) {
		var parentID = $("#tenders-tree").jstree("get_selected")[0];
		parentID = parentID.split("_").pop();
	}

	$.ajax({
		type: "DELETE",
		url:  "/tenders/group/" + parentID,
		success: function(response) {
			if (response.success) {
				reloadTendersTree();
			}
		}
	});
}

function promptForNewTenderGroupName() {
	if (!$("#tenders-tree").jstree("get_selected").length) return;

	var parentID = $("#tenders-tree").jstree("get_selected")[0];
	var label = $("#" + parentID).text().trim();
	var tenderID = parentID.split("_").pop();

	inputDialog({
			dialoglabel: "",
			inputlabels: ["New name"],
			defaults:    [label]
		},
		function done(isConfirmed, formData){
			if(isConfirmed) {
				var newName = formData[0]["value"];
				renameTender(tenderID, newName);
			}
		}
	);
}

function renameTender(id, newName) {
	$("#edit-tenders-group-btn").setButtonActive();

	$.ajax({
		type: "PATCH",
		url: "/tenders/" + id,
		data: {
			details: newName
		},
		success: function(response) {
			$("#edit-tenders-group-btn").setButtonCompleted(response.success);

			if (response.success) {
				reloadTendersTree();
			}
		},
		error: function() {
			$("#edit-tenders-group-btn").setButtonFailed();
		}
	});
}

function tryTenderGroupMove() {
	var button = $("#move-tender-group-btn");

	if (button.text() === "Move") {
		startTenderGroupMove();
	} else {
		confirmTenderGroupMove();
	}
}

function startTenderGroupMove() {
	if (!$("#tenders-tree").jstree("get_selected").length) return;

	var branchID = $("#tenders-tree").jstree("get_selected")[0];

	var button = $("#move-tender-group-btn");
	button.text("Confirm");
	button.attr("data-branch", branchID);
	button.prop("disabled",    true);
	$("#cancel-move-tender-group-btn").css("display", "initial");
}

function confirmTenderGroupMove() {
	if (!$("#tenders-tree").jstree("get_selected").length) return;

	var button = $("#move-tender-group-btn");

	var branchID = button.attr("data-branch").split("_").pop();
	var targetID = $("#tenders-tree").jstree("get_selected")[0].split("_").pop();

	var nestLevel = $("#" + $("#tenders-tree").jstree("get_selected")[0])
										.parents("li").length + 2;

	$.ajax({
		type: "PATCH",
		url:   "/tenders/group/" + branchID + "/move/" + targetID,
		data: {
			level: nestLevel
		},
		success: function(response) {
			reloadTendersTree();
		}
	});

	endTenderGroupMove();
}

function endTenderGroupMove() {
	var button = $("#move-tender-group-btn");
	button.text("Move");
	$("#cancel-move-tender-group-btn").css("display", "none");
	button.prop("disabled", false);
}

function tryTenderMove() {
	var button = $("#move-tender-btn");

	if (button.text() === "Move") {
		startTenderMove();
	} else {
		confirmTenderMove();
	}
}

function startTenderMove() {
	if (tendersGrid.getSelectedRowID() == -1) return;

	var tenderID = tendersGrid.getSelectedRowID();

	var button = $("#move-tender-btn");
	button.text("Confirm");
	button.attr("data-tender", tenderID);
}

function confirmTenderMove() {
	var button = $("#move-tender-btn");

	var tenderID = button.attr("data-tender");
	var targetID = $("#tenders-tree").getSelectedBranchID();

	$.ajax({
		type: "PATCH",
		url:   "/tenders/" + tenderID + "/move/" + targetID,
		success: function(response) {
			reloadTendersTree();
			loadTendersData(targetID);
		}
	});

	endTenderMove();
}

function endTenderMove() {
	var button = $("#move-tender-btn");
	button.text("Move");
	button.prop("disabled", false);
}

function confirmTenderDelete() {
	if (tendersGrid.getSelectedRowID() == -1) return;

	swal({
		title: "Delete Tender",
		text: "Are you sure you wish to delete the selected tender?",
		type: "warning",
		showCancelButton: true,
		confirmButtonColor: "#DD6B55",
		confirmButtonText: "Yes, delete it!",
		closeOnConfirm: true
	},
	deleteSelectedTender);
}

function deleteSelectedTender() {
	$.ajax({
		type: "DELETE",
		url:  "/tenders/" + tendersGrid.getSelectedRowID(),
		success: function(response) {
			if (response.success) {
				loadTendersData($("#tenders-tree").getSelectedBranchID());
				endTenderMove();
			}
		}
	});
}

function promptForTenderName() {
	inputDialog({
			dialoglabel: "",
			inputlabels: ["Tender ref"]
		},
		function done(isConfirmed, formData){
			if(isConfirmed) {
				var ref = formData[0]["value"];
				addTender(ref);
			}
		}
	);
}

function addTender(ref) {
	var branchID = -1;

	if ($("#tenders-tree").hasSelectedBranch()) {
		branchID = $("#tenders-tree").getSelectedBranchID();
	}

	$.ajax({
		type: "POST",
		url:  "/tenders",
		data: {
			contract_id:     CONTRACT_ID,
			parent_group_id: branchID,
			ref:             ref
		},
		success: function(response) {
			loadTendersData(branchID);
		}
	});
}

function postTendersCSV(formData) {
	$("#confirm-upload-button").setButtonActive();

	var branchID = $("#tenders-tree").getSelectedBranchID();

	formData.append("contract_id", CONTRACT_ID);
	formData.append("parent",      branchID);

	$.ajax({
		type: 'POST',
		url: '/tenders/import',
		data: formData,
		contentType: false,
		processData: false,
		success: function(response) {
			loadTendersData(branchID);
			$("#confirm-upload-button").setButtonCompleted(response.success);
			tendersCSVUploader.closeDialogs();
		},
		error: function() {
			$("#confirm-upload-button").setButtonFailed();
		}
	});
}
