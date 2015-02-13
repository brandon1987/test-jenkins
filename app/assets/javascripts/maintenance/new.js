//= require "./mjobscreen/save_mjob"
//= require "./mjobscreen/file_upload"
//= require "./visits"
//= require "../../../../vendor/assets/javascripts/jquery.nicefileinput.min.js"
//= require "./mjobscreen/streamupdates"





$(document).ready(function() {
	$("#filelistloading").hide();
	$("#maintabs").tabs();
	$("#maintabs").show();
	
	$('#customfieldspane').perfectScrollbar();	

	$("#mjobsalestype").select2({
		dropdownAutoWidth:true,
	});

	$(".customfielddropdown").select2({
		dropdownAutoWidth:true,
	});

	$('.clockpicker').clockpicker()
		.find('input').change(function(){
			console.log(this.value);
	});

	$(".datepicker").datepicker({
		"dateFormat":"dd/mm/yy"
	});

	$("#popup_priority").change(function(){

		if (CURRENT_MJOB==-1){
			var currentdate = new Date();
			currentdate.setHours (currentdate.getHours()+parseInt($("#popup_priority").select2().find(":selected").attr("data-interval")));
			$("#startdate").val($.format.date(currentdate.getTime(), "dd/MM/yy"));
			$("#starttime").val($.format.date(currentdate.getTime(), "HH:mm"));
		}
	});

 	$("#popup_contract").change(function(){
 		reloadSiteAddressDropdown();
 	});



 	function reloadSiteAddressDropdown(){
		tinyAjaxLoad("POST","/partials/popups/site_address_popup",{'xidcontract':$("#popup_contract").select2("val"),'withaddbutton':true,'addressid':$("#popup_siteaddress").select2("val")},function(data){
			$('#popup_siteaddress').select2("destroy");	
			$('#siteaddpopupanchor').html(""); 							
			$('#siteaddpopupanchor').html(data); 
			$('#popup_customer').select2("val",$('#popup_contract').select2().find(":selected").data("xidcustomer"));
			init_site_add_popup();
		});
 	}



	$("#tab_0_tabs").tabs({
		activate:function(event,ui){
			switch($("#tab_0_tabs").tabs("option","active")){
		  		case 1:
		  			try{

			  			candidateGrid.adjustGridAndToggleSize(); //invisible grids don't resize their columns correctly so we have to do this when we show an accordion tray with a grid in it
			  			currentVisitGrid.adjustGridAndToggleSize(); //invisible grids don't resize their columns correctly so we have to do this when we show an accordion tray with a grid in it
		  			}catch(e){}
		  			break;
		  		default:
		  			break;
			}
		}
	});


	$("#maintabs").tabs({
		activate:function(event,ui){
			switch($("#maintabs").tabs("option","active")){
				case 1:
					taskStatusChangesGrid.adjustGridAndToggleSize();
						labourTransactionsGrid.totalsRow("update");	

					break;
				case 3:
					try{
						reloadAttachedFilesDirectoryTree();     
						taskAttachedFilesGrid.adjustGridAndToggleSize();
						labourTransactionsGrid.totalsRow("update");							
					}catch(e){}	//don't want to be throwing errors for this, its possible they are already switching tabs before this table finishes loading.			
					break;
				case 4:
					try{

						labourTransactionsGrid.adjustGridAndToggleSize();
						materialsTransactionsGrid.adjustGridAndToggleSize();
						certificatesTransactionsGrid.adjustGridAndToggleSize();
						
						labourTransactionsGrid.totalsRow("update");
						materialsTransactionsGrid.totalsRow("update");
						certificatesTransactionsGrid.totalsRow("update");
					}catch(e){}	//don't want to be throwing errors for this, its possible they are already switching tabs before this table finishes loading.			
					break;					
				default:
			}
		}
	})

	$("#mjob_save_button").click(function(){
		saveMJob();
	});
	$("#mjob_new_button").click(function(){
		document.location = "/maintenance/new";
	});	
	$("#testaws").click(function(){
			$.ajax({
			type: 'get',
			url: '/maintenance/testaws',
			data: {},
			success: function(data) {
				console.log(data);
			}
		}); 	
	});	

	if (typeof CURRENT_MJOB !== 'undefined'){
		backgroundMJobDataLoad();
	}

	if(DISABLEMJOBREFBOX){
		$("#mjob").prop("disabled",true);
		$("#mjob").attr("placeholder", "Auto Generated");
	}



	//websocket handlers
	websocket.on('site_address_reload', function(msg){
		reloadSiteAddressDropdown();
	});	
	websocket.on('mjob_visit_reload', function(msg){
		if (msg==CURRENT_MJOB){ //only want to reload this if it is the mjob we are currently looking at.
			//reloadVisitsList();  don't want to reload this any more as we are now not saving visits until the save button is clicked. don't want to lose edits uneecessarily
		}
	});
	websocket.on('mjob_file_attach_reload', function(msg){
		if (msg==CURRENT_MJOB){ //only want to reload this if it is the mjob we are currently looking at.
			reloadAttachedFilesDirectoryTree();
		}
	});
});






function loadTaskStatusChangeGrid(){
	taskStatusChangesGrid= $('#taskstatuschangesgrid').dataTable( {
        "aoColumnDefs": [
 			{ "sClass": "laligncol",  "aTargets": [0,1,2] },
        ],		
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth":true,
		"sScrollY" : 395, 
	});
}



function loadLabourTransactionsGrid(){
	labourTransactionsGrid= $('#labourtransactionsgrid').dataTable( {
        "aoColumnDefs": [
 			{ "sClass": "laligncol",  "aTargets": [0,1,2,3,4] },
 			{ "sClass": "raligncol",  "aTargets": [5,6] },
 			{ "sClass": "currency-column",  "aTargets": [7,9,10] },
        ],		
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth":true,
	});
	labourTransactionsGrid.columnFilters();
	labourTransactionsGrid.totalsRow('5,6,7,9,10');
	labourTransactionsGrid.totalsRow("update");

}

function loadMaterialsTransactionsGrid(){
	materialsTransactionsGrid= $('#materialstransactionsgrid').dataTable( {
        "aoColumnDefs": [
 			{ "sClass": "laligncol",  "aTargets": [0,1,2,3,4,5,6,7] },
 			{ "sClass": "raligncol",  "aTargets": [11,12] },
 			{ "sClass": "currency-column",  "aTargets": [8,9,10] },
        ],		
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth":true,
	});
	materialsTransactionsGrid.columnFilters();
	materialsTransactionsGrid.totalsRow('8,9,10');
	materialsTransactionsGrid.totalsRow("update");

}

function loadCertificatesTransactionsGrid(){
	certificatesTransactionsGrid= $('#certificatestransactionsgrid').dataTable( {
        "aoColumnDefs": [
 			{ "sClass": "laligncol",  "aTargets": [0,1,2,3,4] },
 			{ "sClass": "currency-column",  "aTargets": [5,6,7,8,9,10,11,12,13,14] },
        ],		
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth":true,
	});
	certificatesTransactionsGrid.columnFilters();
	certificatesTransactionsGrid.totalsRow('5,6,7,8,9,10,11,12,13,14');
	certificatesTransactionsGrid.totalsRow("update");
}







function backgroundMJobDataLoad(){
	tinyAjaxLoad("POST","/partials/maintenance/maintenance_task_status_changes",{'id':CURRENT_MJOB},function(data){
		$("#taskstatuschangesgrid").html(data);
		loadTaskStatusChangeGrid();
	});
	reloadAttachedFilesList();
	reloadAttachedFilesDirectoryTree();
	tinyAjaxLoad("POST","/partials/maintenance/maintenance_transactions_labour",{'id':CURRENT_MJOB},function(data){
		$("#labourtransactions").html(data);
		loadLabourTransactionsGrid();
	});
	tinyAjaxLoad("POST","/partials/maintenance/maintenance_transactions_materials",{'id':CURRENT_MJOB},function(data){
		$("#materialstransactions").html(data);
		loadMaterialsTransactionsGrid()
	});
	tinyAjaxLoad("POST","/partials/maintenance/maintenance_transactions_certificates",{'id':CURRENT_MJOB},function(data){
		$("#certificatetransactions").html(data);
		loadCertificatesTransactionsGrid()
	});
	
}




$(document).ready(function(){
	
	$("tr input, tr select").focus(function(){
		$(this).parent().prev().css("color", "#000");
	});
	
	$("tr input, tr select").blur(function(){
		$(this).parent().prev().css("color", "inherit");
	});
	
	$(".clockpicker input").focus(function(){
		$(this).parent().parent().prev().css("color", "#000");
	});
	
	$(".clockpicker input").blur(function(){
		$(this).parent().parent().prev().css("color", "inherit");
	});
	
	$("tr textarea").focus(function(){
		$(this).parent().children(":first-child").css("color", "#000");
	});
	
	$("tr textarea").blur(function(){
		$(this).parent().children(":first-child").css("color", "inherit");
	});
	
	$("select").on("select2-open", function() { 
		$(this).parent().prev().css("color","#000");
	});
	$("select").on("select2-close", function() { 
		$(this).parent().prev().css("color","inherit");
	});


});

function showAddSiteAddress(){
	$("#siteaddresspopupform").dialog({
		title:"Site Address",
		width:800,
		height:530
	});
}



