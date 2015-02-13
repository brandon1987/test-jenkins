$(function() {
	setUpStatusTable();
	watchStatusTableChanges();
	$("#add-custom-status-btn").click(addCustomStatus);

	$("#quote-status-table").on("click", "button.delete-button", deleteStatus);
});




function setUpStatusTable() {
	quoteStatusTable = $("#quote-status-table").dataTable({
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false,
		"columnDefs": [
			{
				"render": function (data, type, row) {
					var checkbox = "";
					checkbox += "<input class=\"js-default-toggle\"  type=\"checkbox\"";
					if (data == 1 || data == "true") {
						checkbox += " checked";
					}
					checkbox += ">";
					return checkbox;
				},
				"targets": [1]
			},
			{
				"render": function (data, type, row) {
					var checkbox = "";
					checkbox += "<input class=\"js-hidden-toggle\" type=\"checkbox\"";
					if (data == 1 || data == "true") {
						checkbox += " checked";
					}
					checkbox += ">";
					return checkbox;
				},
				"targets": [2]
			},
			{
				"render": function (data, type, row) {
					var status = row[0];
					var button = "";
					if ( status != "Open" && status != "Ordered" && status != "Lost" && status != "Inactive" ) {
						button = "<button class=\"delete-button\">Delete</button>";
					}

					return button;
				},
				"targets": [3]
			}
		],
		"fnDrawCallback": function() {
			setCheckboxTheme("#quote-status-table");
		}
	});
}

function addCustomStatus() {
	var statusName = $("#new-custom-status-name").val();

	if (statusName == "") return;

	$.ajax({
		type:    "POST",
		url:     "/quote_statuses",
		data:    {
			status: {
				name: statusName
			}
		},
		success: function(response) {
			if (response.success) {
				reloadStatusTable();
			}
		}
	});
}

function reloadStatusTable() {
	quoteStatusTable.fnReloadAjax("/quote_statuses.json")
}

function deleteStatus() {
	var button = $(this);
	var id = button.parents("tr").first().attr("id").split("_").pop();

	$.ajax({
		type: "DELETE",
		url:  "/quote_statuses/" + id,
		success: function(response) {
			reloadStatusTable();
		}
	})
}

function watchStatusTableChanges() {
	$('#quote-status-table').on('ifChecked', ".js-default-toggle", function(event){
		$(".js-default-toggle").not($(this)).iCheck("uncheck");
		var checkedID = $(this).parents("tr").first().attr("id").split("_").pop();

		$.ajax({
			type: "PATCH",
			url:  "/quote_statuses/" + checkedID + "/set_default"
		});
	});

	$('#quote-status-table').on('ifToggled', ".js-hidden-toggle", function(event){
		var checkedID = $(this).parents("tr").first().attr("id").split("_").pop();
		var status    = $(this).is(":checked");

		$.ajax({
			type: "PATCH",
			url:  "/quote_statuses/" + checkedID,
			data: { status: { is_hidden: status } }
		});
	});
}


