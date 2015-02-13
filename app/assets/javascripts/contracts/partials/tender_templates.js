$(function(){
	setUpTenderTemplateValuesTable();

	$("#save-tender-template-btn").click(saveTenderTemplateFromContract);
	$("#new-tender-template-btn").click(promptForNewTenderTemplateName);
	$("#rename-tender-template-btn").click(promptForTenderTemplateRename);
	$("#delete-tender-template-btn").click(confirmDeleteTenderTemplate);
	$("#default-tender-template-btn").click(setDefaultTenderTemplate);

	$("#tenders-template-list").prop("selectedIndex", -1);

	// Groups
	$("#add-tender-template-group-btn").click(promptForNewTemplateGroupName);
	$("#rename-tender-template-group-btn").click(promptForTemplateGroupRename);
	$("#delete-tender-template-group-btn").click(confirmDeleteTemplateGroup);

	// Template items
	$('#import-tender-template-items-btn').click(function() {
		$('#tendertemplateitems-import-dialog').dialog( 'open' );
	});
	$("#remove-tender-template-item-btn").click(deleteTemplateItem);
});

function setUpTenderTemplateValuesTable() {
	tenderTemplateValuesTable = $("#tender-template-values-table").dataTable( {
		//"sScrollY": "200px",
		"bScrollCollapse": true,
		"bPaginate": false,
		"columnDefs": [
			{
				"sClass": "selectcell",
				"render": function (data, type, row) {
					return "<input class=\"cleanbox-editable-cell\" value=\"" + data + "\">";
				},
				"targets": [0, 1, 2]
			}
		],
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false,
	});

	tenderTemplateValuesTable.enableSingleRowSelection();
}

function saveTenderTemplateFromContract(name) {
	$("#save-tender-template-btn").setButtonActive();
	$.ajax({
		type:    "POST",
		url:     "/tender_templates/create_from_contract",
		data:    { contract_id: CONTRACT_ID },
		success: function(response) {
			$("#save-tender-template-btn").setButtonCompleted(response.success);

			if(response.success) {
				swal("Template saved", "", "success")
			}
		}
	});
}

function setUpTendersDialog() {
	$("#tender-templates-dlg").dialog({
		width: 'auto',
		modal: true,
		autoOpen: false,
		resizable: false
	});

	$("#open-tender-dlg-btn").click(function(){
		$("#tender-templates-dlg").dialog("open");
	})

	$("#tenders-template-list").change(function(){
		var tenderID = $("#tenders-template-list").val();
		reloadTenderTemplatesTree(tenderID);
	});
}

function reloadTenderTemplatesTree(tenderID) {
	$('#tenders-template-tree').jstree("destroy");

	$.ajax({
		type: "GET",
		url: "/tender_templates/" + tenderID + "/tree.json",
		success: function(data) {
			$('#tenders-template-tree').jstree({ 'core' : {
				'data' : data
			}});

			setUpTenderTemplatesTree();
		}
	});
}

function setUpTenderTemplatesTree() {
	$('#tenders-template-tree')
		.on('select_node.jstree', function (node, selected, event) {
			var id = selected.node.id.split("_").pop();
			loadTenderTemplateData(id);

			var nestLevel = $("#" + $("#tenders-template-tree").jstree("get_selected")[0])
										.parents("li").length;
			$("#tenders-add-group-btn").prop("disabled", nestLevel === 2);

			var moveButton = $("#move-tender-group-btn");
			if (moveButton.text() === "Confirm") {
				moveButton.prop("disabled", selected.node.id === moveButton.attr("data-branch"));
			}
		})
		.jstree();
}

function loadTenderTemplateData(templateBranchID) {
	var newURL = "/tender_templates/" + templateBranchID + "/grid_data";
	tenderTemplateValuesTable.fnReloadAjax(newURL);
}

function promptForNewTenderTemplateName() {
	inputDialog({
			dialoglabel: "",
			inputlabels: ["Template name"],
		},
		function done(isConfirmed, formData){
			if(isConfirmed) {
				var templateName = formData[0]["value"];
				createTenderTemplate(templateName);
			}
		}
	);
}

function createTenderTemplate(name) {
	$.ajax({
		type: "POST",
		url:  "/tender_templates",
		data: { name: name },
		success: function(response) {
			if (response.success) {
				$("<option/>").attr("value", response.new_id)
							.text(name)
							.appendTo("#tenders-template-list");
			}
		}
	})
}

function promptForTenderTemplateRename() {
	inputDialog({
			dialoglabel: "",
			inputlabels: ["Rename template"],
		},
		function done(isConfirmed, formData){
			if(isConfirmed) {
				var newName = formData[0]["value"];
				renameTemplate(newName);
			}
		}
	);
}

function renameTemplate(newName) {
	var templateID = $("#tenders-template-list").val();

	$.ajax({
		type: "PATCH",
		url:  "/tender_templates/" + templateID,
		data: { name: newName },
		success: function(response) {
			if (response.success) {
				$("#tenders-template-list option[value=" + templateID + "]").text(newName);
			}
		}
	})
}

function confirmDeleteTenderTemplate() {
	swal({
		title: "Delete Template",
		text: "Are you sure you wish to delete the selected template?",
		type: "warning",
		showCancelButton: true,
		confirmButtonColor: "#DD6B55",
		confirmButtonText: "Yes, delete it!",
		closeOnConfirm: true
	},
	deleteTenderTemplate);
}

function deleteTenderTemplate() {
	var templateID = $("#tenders-template-list").val();

	$.ajax({
		type: "DELETE",
		url:  "/tender_templates/" + templateID,
		success: function(response) {
			if (response.success) {
				$("#tenders-template-list option[value=" + templateID + "]").remove();
			}
		}
	})
}

function setDefaultTenderTemplate() {
	var templateID = $("#tenders-template-list").val();

	$.ajax({
		type: "PATCH",
		url: "/tender_templates/" + templateID + "/set_default",
		success: function(response){
			if (response.success) {
				$("#tenders-template-list .default").removeClass("default");
				$("#tenders-template-list option[value=" + templateID + "]").addClass("default");
			}
		}
	})
}

function promptForNewTemplateGroupName() {
	inputDialog({
			dialoglabel: "",
			inputlabels: ["Group name"],
		},
		function done(isConfirmed, formData){
			if(isConfirmed) {
				var newName = formData[0]["value"];
				createNewTemplateGroup(newName);
			}
		}
	);
}

function createNewTemplateGroup(name) {
	var parentID = $('#tenders-template-tree').getSelectedBranchID();
	var templateID = $("#tenders-template-list").val();

	$.ajax({
		type: "POST",
		url:  "/tender_template_items/create_group",
		data: {
			group_id:    parentID,
			details:     name,
			template_id: templateID
		},
		success: function(response) {
			if (response.success) {
				reloadTenderTemplatesTree(templateID);
			}
		}
	});
}

function promptForTemplateGroupRename() {
	inputDialog({
			dialoglabel: "",
			inputlabels: ["New name"],
		},
		function done(isConfirmed, formData){
			if(isConfirmed) {
				var newName = formData[0]["value"];
				renameTemplateGroup(newName);
			}
		}
	);
}

function renameTemplateGroup(newName) {
	var branchID = $('#tenders-template-tree').getSelectedBranchID();

	$.ajax({
		type:    "PATCH",
		url:     "/tender_template_items/" + branchID,
		data:    { details: newName },
		success: function(response) {
			reloadTenderTemplatesTree($("#tenders-template-list").val());
		}
	});
}

function confirmDeleteTemplateGroup() {
	var branchID = $('#tenders-template-tree').getSelectedBranchID();
	if (branchID == -1) return;

	swal({
		title: "Delete Group",
		text: "Are you sure you wish to delete this group and everything it contains?",
		type: "warning",
		showCancelButton: true,
		confirmButtonColor: "#DD6B55",
		confirmButtonText: "Yes, delete it!",
		closeOnConfirm: true
	},
	deleteTemplateGroup);
}

function deleteTemplateGroup() {
	var branchID = $('#tenders-template-tree').getSelectedBranchID();

	$.ajax({
		type: "DELETE",
		url:  "/tender_template_items/" + branchID,
		success: function(response) {
			if (response.success) {
				reloadTenderTemplatesTree($("#tenders-template-list").val());
			}
		}
	})
}

function deleteTemplateItem() {
	var itemID = tenderTemplateValuesTable.getSelectedRowID();
	if (itemID == -1) return;

	$("#remove-tender-template-item-btn").setButtonActive();

	$.ajax({
		type: "DELETE",
		url:  "/tender_template_items/" + itemID,
		success: function(response) {
			$("#remove-tender-template-item-btn").setButtonCompleted(response.success);

			if (response.success) {
				loadTenderTemplateData($('#tenders-template-tree').getSelectedBranchID());
			}
		}
	})
}

function postTendersTemplateItemsCSV(formData) {
	formData.append("group_id",    $('#tenders-template-tree').getSelectedBranchID());
	formData.append("template_id", $("#tenders-template-list").val());

	$('#import-tender-template-items-btn').setButtonActive();
	$.ajax({
		type:    "POST",
		url:     "/tender_template_items/import",
		data:    formData,
		contentType: false,
		processData: false,
		success: function(response) {
			$('#import-tender-template-items-btn').setButtonCompleted(response.success);

			loadTenderTemplateData($('#tenders-template-tree').getSelectedBranchID());
			tendersCSVUploader.closeDialogs();
		}
	});
}

