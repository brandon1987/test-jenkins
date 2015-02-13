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
});

function openBlankReport() {
	var address = "http://reports.constructionmanager.net/api/new.php?companyID=" + COMPANY_ID;
	window.open(address);
}

function openSelectedReport() {
	var report = reportsGrid.getSelectedRowID();
	openReportInDesigner(report);
}

function openReportInDesigner(filename) {
	var address = "http://reports.constructionmanager.net/api/edit.php?companyID=" + COMPANY_ID + "&filename=" + filename;
	//var address = "http://localhost/cm-services/reports/stimulsoft/api/edit.php?companyID=" + COMPANY_ID + "&filename=" + filename;

	window.open(address);
}

function checkReportDelete() {
	if (!reportsGrid.hasSelectedRows()) return;

	var button = $('#delete-report-button');

	if(button.attr('data-confirm') === "1") {
		button.text('Delete');
		button.attr('data-confirm', 0 );
		button.removeClass('button-toggled-on');
		deleteSelectedReport();
	} else {
		button.text('Confirm Delete');
		button.attr('data-confirm', 1 );
		button.addClass('button-toggled-on');
	}
}

function deleteSelectedReport() {
	$.ajax({
		type: 'DELETE',
		url: '/reports/' + reportsGrid.getSelectedRowID(),
		success: function() {
			reportsGrid.deleteSelectedRows();
		}
	});
}

function setDefaultReport() {
	$.ajax({
		type: "POST",
		url: "/reports/set_default/" + reportsGrid.getSelectedRowID(),
		success: function() {
			$("#reports-table .fa-check").remove();
			var row = reportsGrid.getSelectedRow();
			row.find("td").eq(1).html('<i class="fa fa-check"></i>');
		}
	});
}

//Animation to show you can scroll table
$(document).ready(function(){	
	var count = $("tbody tr").length;
	var index = $( ".fa-check" ).parent().parent().index();
	
	if(count/2>index){
		$('.dataTables_scrollBody').scrollTop($('tbody tr:last-child').position().top);
		$('.dataTables_scrollBody').animate({
            scrollTop: $(".fa-check").position().top
        }, 1000);
	}
	else{
		$('.dataTables_scrollBody').animate({
            scrollTop: $(".fa-check").position().top
        }, 1000);
	}	
});