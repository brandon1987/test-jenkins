$(function(){
	reportsGrid = $("#reports-table").dataTable( {
		"aoColumnDefs": [
			{ "sClass": "laligncol",  "aTargets": [0] },
			{ "sClass": "caligncol",  "aTargets": [1] }
		],
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": false,
		"sScrollY" : ($(".content-main").height() - 200)
	});

	reportsGrid.enableSingleRowSelection();
	reportsGrid.onRowDoubleClicked(openSelectedReport);

	$("#new-report-button").click(openBlankReport);
	$("#edit-report-button").click(openSelectedReport);
	$("#delete-report-button").click(checkReportDelete);
	$("#default-report-button").click(setDefaultReport);
	$("#upload-report-button").click(openUploadDialog);

	REPORTS_URL = "http://reports.constructionmanager.net/";

	if (window.location.href.indexOf("localhost") > 0) {
		REPORTS_URL = "http://localhost/cm-services/reports/stimulsoft/";
	}

	setUpUploadDialog();
});

function setUpUploadDialog() {
	$("#report-upload-dlg").dialog({
		width: '300px',
		modal: 'true',
		autoOpen: false
	});
}

function openUploadDialog() {
	$("#report-upload-dlg").dialog("open");
}

function openBlankReport() {
	var address = REPORTS_URL + "api/new.php?companyID=" + COMPANY_ID;
	window.open(address);
}

function openSelectedReport() {
	var report = reportsGrid.getSelectedRowID();
	openReportInDesigner(report);
}

function openReportInDesigner(filename) {
	var address = REPORTS_URL + "api/edit.php?companyID=" + COMPANY_ID + "&filename=" + filename;
	window.open(address);
}

function checkReportDelete() {
	if (!reportsGrid.hasSelectedRows()) return;

	swal({
		title: "Delete report",
		text: "Are you sure you wish to delete this report?",
		status: "warning",
		showCancelButton: true,
		confirmButtonColor: "#DD6B55",
		confirmButtonText: "Delete",
	}, deleteSelectedReport);
}

function deleteSelectedReport() {
	$.ajax({
		type: 'DELETE',
		url: '/reports/' + reportsGrid.getSelectedRowID(),
		success: function(response) {
			if (response.success) {
				reportsGrid.deleteSelectedRows();
			}
		}
	});
}

function setDefaultReport() {
	$.ajax({
		type: "POST",
		url: "/reports/set_default/" + reportsGrid.getSelectedRowID(),
		success: function(response) {
			if (response.success) {
				$("#reports-table .fa-check").remove();
				var row = reportsGrid.getSelectedRow();
				row.find("td").eq(1).html('<i class="fa fa-check"></i>');
			}
		}
	});
}