completingvisits=[]

$(document).ready(function() {



	$("#addvisitbutton").click(function(){
		addVisit();
	});

	$("#visitdeletebutton").click(function(){
		deleteVisit();
	});

	$("#reassigncancel").click(function(){
		$('#visitreassigndialog').dialog("close");
	});

	$("#reassignconfirm").click(function(){
		reassignVisit();
		$('#visitreassigndialog').dialog("close");
	});	

	$("#visitreassignbutton").click(function(){
		$('#visitreassigndialog').dialog({width:'auto',
										  title:'Reassign Visit'	
		});
	});



	

	$("#addvisitbutton").prop("disabled", true);

	backgroundVisitDataLoad();




});


function loadVisitCandidateGrid(){
	candidateGrid = $('#visitcandidates').dataTable( {
        "aoColumnDefs": [
 			{ "sClass": "laligncol",  "aTargets": [0] } 
        ],		
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": true,
		"sScrollY" : 145,
		"fnInitComplete": function() {
			$("#visitcandidates, .dataTables_scrollHeadInner table").animate({
				opacity: 1
			}, 500);
		}     
	});
	candidateGrid.columnFilters();

	candidateGrid.adjustGridAndToggleSize();
	candidateGrid.enableSingleRowSelection();
	candidateGrid.onRowSelected(function(id,row){

	$("#addvisitbutton").prop("disabled", false);

	});	

}



function loadCurrentVisitGrid(){
		currentVisitGrid = $('#currentvisits').dataTable( {
        "aoColumnDefs": [
 			{ "sClass": "laligncol visitcolumns",  "aTargets": [0,1,2 ] }
        ],		
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": true,
		"sScrollY" : 136,
		"fnInitComplete": function() {
			$("#visitcandidates, .dataTables_scrollHeadInner table").animate({
				opacity: 1
			}, 500);
		}     
	});
	setVisitControlsEnabled(false)	
	currentVisitGrid.columnFilters();
	currentVisitGrid.adjustGridAndToggleSize();
	currentVisitGrid.enableSingleRowSelection();
	currentVisitGrid.gridTooltips();

	currentVisitGrid.onRowSelected(function(id,row){

	    $("#popup_integrationvisitstatus").select2("val",$(row).attr("data-status"));
	    $("#visitinstructions").val($(row).attr("data-instructions"));
	    $("#visitworkcarriedout").val($(row).attr("data-workcarriedout"));
	    $("#visitmaterialsused").val($(row).attr("data-materialsused"));

	    $("#plannedstartdate").val(getDateFromEpoch($(row).attr("data-plannedstart")));
	    $("#plannedstarttime").val(getTimeFromEpoch($(row).attr("data-plannedstart")));

	    $("#plannedenddate").val(getDateFromEpoch($(row).attr("data-plannedend")));
	    $("#plannedendtime").val(getTimeFromEpoch($(row).attr("data-plannedend")));

	    $("#workstartdate").val(getDateFromEpoch($(row).attr("data-workstart")));
	    $("#workstarttime").val(getTimeFromEpoch($(row).attr("data-workstart")));

	    $("#workenddate").val(getDateFromEpoch($(row).attr("data-workend")));
	    $("#workendtime").val(getTimeFromEpoch($(row).attr("data-workend")));

	    $("#timetravelling").val(getTimeFromEpoch($(row).attr("data-timetravelling")));
	    $("#timeonsite").val(getTimeFromEpoch($(row).attr("data-timeonsite")));


	    if($(row).attr("data-appointmentid")==""){
			if ($(row).attr("data-appointmentstart")==""){
		    	$("#visitappointmentview").hide();	    	
	    		$("#visitappointmentcreationnotice").hide();
		    	$("#visitappointmentcreate").show();
			}else{
		    	$("#visitappointmentview").hide();
		    	$("#visitappointmentcreate").hide();					
	    		$("#visitappointmentcreationnotice").show();
			}
	    }else{
	    	$("#visitappointmentcreationnotice").hide();
	    	$("#visitappointmentcreate").hide();
	    	$("#visitappointmentview").show();	    	
		}	

		setVisitControlsEnabled(true);
		if(id>=0){
			//load additional information about the visit seperately
			$.ajax({
				type: 'get',
				url: '/maintenance_visit/loadvisit',
				data: {'xidvisit':row.attr("data-visitref"),
					   'xidxml':row.attr("data-xidxml"),
					   'id':id
					},
				success: function(data) {

					//load all our visit stuff at once. Loads the @maintenancevisit in ruby whilst also loading the status changes lists and xml lists.
					dataobjects=JSON.parse(data)

					visitStatusGrid.fnDestroy();
					$("#maintenancevisitstatuschanges").empty();		
					$("#maintenancevisitstatuschanges").html(dataobjects.statuschanges);
					loadVisitStatusGrid();

					visitXMLGrid.fnDestroy();
					visitXMLGrid.unbind();
					$("#maintenancevisitxml").empty();		
					$("#maintenancevisitxml").html(dataobjects.customforms);
					loadVisitXMLGrid();	
		
				}
			});
		}
	});
	currentVisitGrid.setSelectedRow(currentVisitGrid.fnGetData().length);

}


function setVisitDateFromEntry(dataProperty,dateinput,timeinput){

	if ($(dateinput).val()!=""){
		if ($(timeinput).val()==""){
			$(timeinput).val("00:00");
		}
		var d=$( dateinput).datepicker("getDate");
		d.setHours($(timeinput).val().substring(0,2));
		d.setMinutes($(timeinput).val().substring(3,5));
		$(currentVisitGrid.getSelectedRow()).attr(dataProperty,d.getTime()/1000);	
		console.log("set"+dataProperty,d.getTime()/1000);

	}else{
		$(currentVisitGrid.getSelectedRow()).attr(dataProperty,0);	
		$(timeinput).val("");
	}

}

function getDateFromEpoch(timestamp){
	if (timestamp!="0"){
    	return $.format.date(parseInt(timestamp*1000), "dd/MM/yy")		
	}else{
		return "";
	}

}

function getTimeFromEpoch(timestamp){
	if (timestamp!="0"){
    	return $.format.date(parseInt(timestamp*1000), "HH:mm")
	}else{
		return "";
	}    
}



function loadVisitStatusGrid(){
	visitStatusGrid = $('#maintenancevisitstatuschanges').dataTable( {
        "aoColumnDefs": [
 			{ "sClass": "laligncol",  "aTargets": [0,1,2] },
        ],		
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth":true,
		"sScrollY" : 490,
		"fnInitComplete": function() {
			$("#visitcandidates, .dataTables_scrollHeadInner table").animate({
				opacity: 1
			}, 500);
		}     
	});
	visitStatusGrid.columnFilters();
	visitStatusGrid.adjustGridAndToggleSize();
	visitStatusGrid.enableSingleRowSelection();
}


function loadVisitXMLGrid(){
	visitXMLGrid = $('#maintenancevisitxml').dataTable( {
        "aoColumnDefs": [
 			{ "sClass": "laligncol",  "aTargets": [0,] },
        ],		
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth":true,
		"sScrollY" : 400,
		"fnInitComplete": function() {
			$("#visitcandidates, .dataTables_scrollHeadInner table").animate({
				opacity: 1
			}, 500);
		}     
	});
	visitXMLGrid.columnFilters();
	visitXMLGrid.adjustGridAndToggleSize();
	visitXMLGrid.enableSingleRowSelection();
	visitXMLGrid.onRowSelected(function(id,row){
		$.ajax({
			type: 'post',
			url: '/maintenance/rendervisitxml',
			data: {'xmldata':row.attr("data-xml")},
			success: function(data) {
				$("#maintenancevisitformcontents").empty();		
				$("#maintenancevisitformcontents").html(data);
				$(".xmlline").tabs();				
				$(".xmlsection").accordion({
					heightStyle: "content" 
				});
				//$(".xmlsection").accordion( "refresh" );
				$(".xmlfieldstable").dataTable( {
			        "aoColumnDefs": [{ "sClass": "laligncol",  "aTargets": [0,1] },],		
					"bPaginate": false,
					"bLengthChange": false,
					"bFilter": false,
					"bSort": false,
					"bInfo": false,
					"bAutoWidth":true,
					}     
				);
			}
		});


	});

}


function addVisit(){
		newrow=currentVisitGrid.api().row.add([candidateGrid.getSelectedRowCellValue(0),"New Visit","Not Sent"]).draw().node();
		$(newrow).attr("id","-1");
		$(newrow).attr("data-instructions","");
		$(newrow).attr("data-status","1");
		$(newrow).attr("data-materialsused","");
		$(newrow).attr("data-workcarriedout","");
		$(newrow).attr("data-engineerid",$(candidateGrid.getSelectedRow()).attr("data-engineerid"));
		$(newrow).attr("data-plannedstart","0");
		$(newrow).attr("data-plannedend","0");
		$(newrow).attr("data-workstart","0");
		$(newrow).attr("data-workend","0");
		$(newrow).attr("data-timetravelling","");
		$(newrow).attr("data-timeonsite","");
		$(newrow).attr("data-appointmentid","");
		$(newrow).attr("data-appointmentstart","");
		$(newrow).attr("data-appointmentend","");
		$(newrow).attr("data-resourcekey",$(candidateGrid.getSelectedRow()).attr("data-resourcekey"));

		currentVisitGrid.setSelectedRow(currentVisitGrid.fnGetData().length);
		setVisitDateFromEntry("data-plannedstart",$("#startdate"),$("#starttime"));
		currentVisitGrid.setSelectedRow(currentVisitGrid.fnGetData().length);//do this twice so that the row is initially selected, then that the date changes if the planned start time changes.

}

function deleteVisit(){

		swal({
		  title: "Are you sure?",
		  text: "You are about to delete the selected visit and any linked information, are you sure you wish to continue?",
		  type: "warning",
		  showCancelButton: true,
		  confirmButtonColor: "#DD6B55",
		  confirmButtonText: "Delete",
		  closeOnConfirm: true
		},
		function(){
			if (currentVisitGrid.getCompleteSelectedRowID()==-1){
				currentVisitGrid.api().row(currentVisitGrid.getSelectedRowPosition()).remove().draw();
			}else{
				$.ajax({
						type: 'delete',
						url: '/maintenance_visit/'+currentVisitGrid.getSelectedRowID(),
						success: function(data) {
			            	websocket.emit('mjob_visit_reload', COMPANY_ID,CURRENT_MJOB);
							currentVisitGrid.api().row(currentVisitGrid.getSelectedRowPosition()).remove().draw();			            							
						}
				});				
			}

		});

}


//'/maintenance_visit/loadvisitlist'   mjobid
function reloadVisitsList(){
	$.ajax({
		type: 'POST',
		url: '/partial/partialrender',
		data: {	'partialname':'/partials/maintenance/maintenance_current_visits',
				'xidmjob':CURRENT_MJOB
		},
		success: function(data) {

				currentVisitGrid.unbind();
				currentVisitGrid.fnDestroy();					
				$("#currentvisits").html(data);
				loadCurrentVisitGrid();	

		}
	});	
}

function reassignVisit(){

	currentVisitGrid.api().cell( currentVisitGrid.getSelectedRowPosition(), 0 ).data($("#popup_engineers").select2('data').text ).draw();

	if ($("#chkreassignrenumber").is(":checked")){
		currentVisitGrid.api().cell( currentVisitGrid.getSelectedRowPosition(), 1 ).data("" ).draw();
		$(currentVisitGrid).getSelectedRow().attr("data-visitref","");		
	}
	$(currentVisitGrid).getSelectedRow().attr("data-engineerid",$("#popup_engineers").val());	
	
	$(currentVisitGrid).getSelectedRow().attr("data-resourcekey",$("#popup_engineers").select2().find(":selected").attr("data-resourcekey"));		

}


function getReassignedVisits(){
	var visits=[];
	currentVisitGrid.find('tr').each(function(index,item){
		if(typeof($(item).attr("id"))!="undefined"){
			if($(item).attr("data-visitref")==""){
				var visit={id:$(item).attr("id"),
					engineername:$(item).children().eq(0).text(),
				   	engineerid:$(item).attr("data-engineerid"),
					resourcekey:$(item).attr("data-resourcekey")		   	
				};
				visits.push(visit);	
			}
		}
	});
	return visits;
}


function setVisitControlsEnabled(isenabled){
	if(isenabled){
		$("#visittabs").tabs("enable");
		$("#visitdeletebutton").prop("disabled", false);	
		$("#visitreassignbutton").prop("disabled", false);	
		$("#popup_integrationvisitstatus").prop('disabled', false);		
		$("#visitinstructions").prop('disabled', false);
		$("#visittimesform").find("*").attr('disabled', false);	
	}else{
		$("#visitinstructions").val("");
		$("#popup_integrationvisitstatus").select2("val",0);		
		$("#visittabs").tabs({ active:0 });
		$("#visittabs").tabs("disable");

		$("#popup_integrationvisitstatus").prop('disabled', true);		
		$("#visitinstructions").prop('disabled', true);	

		$("#visitdeletebutton").prop("disabled", true);	
		$("#visitreassignbutton").prop("disabled", true);	
		$("#visittimesform").find("*").attr('disabled', true);	
	}


}




function backgroundVisitDataLoad(){

	tinyAjaxLoad("POST","/partials/maintenance/maintenance_visit_candidates",{},function(data){
		$("#visitcandidates").html(data);
		loadVisitCandidateGrid();
	});

	tinyAjaxLoad("POST","/partials/maintenance/maintenance_visit_tabs",{},function(data){
		$("#maintenancevisittabs").html(data);
	
		loadVisitStatusGrid();
		loadVisitXMLGrid();
		$("#visittabs").tabs();
		$("#visittabs").tabs({ selected: 0});
		$("#visittabs").tabs({
			activate:function(event,ui){
				switch($("#visittabs").tabs("option","active")){
					case 2:
						visitXMLGrid.adjustGridAndToggleSize();
						break;
					case 3:
						visitStatusGrid.adjustGridAndToggleSize();//invisible grids don't resize their columns correctly so we have to do this when we show an accordion tray with a grid in it
						break;
					default:
				}
			}
		});
		setVisitControlsEnabled(false)


		$("#popup_integrationvisitstatus").change(function(){
			currentVisitGrid.api().cell( currentVisitGrid.getSelectedRowPosition(), 2 ).data( $("#popup_integrationvisitstatus").select2('data').text ).draw()
			$(currentVisitGrid).getSelectedRow().attr("data-status",$("#popup_integrationvisitstatus").select2("val"));
			var id=$(currentVisitGrid).getSelectedRow().attr("id");
			if ($("#popup_integrationvisitstatus").select2("val")==9){
				if (completingvisits.indexOf(id)==-1){
					completingvisits.push(id);
				}
			}else{
				if (completingvisits.indexOf(id)!=-1){
					completingvisits.splice(completingvisits.indexOf(id),1);
				}
			}
		});

		$("#visitinstructions").change(function(){
			$(currentVisitGrid).getSelectedRow().attr("data-instructions",$("#visitinstructions").val());
		});

		$("#visitworkcarriedout").change(function(){
			$(currentVisitGrid).getSelectedRow().attr("data-workcarriedout",$("#visitworkcarriedout").val());
		});
		$("#visitmaterialsused").change(function(){
			$(currentVisitGrid).getSelectedRow().attr("data-materialsused",$("#visitmaterialsused").val());
		});			


		$('.visitclockpicker').clockpicker()
			.find('input').change(function(){

		});

		$(".visitdatepicker").datepicker({
			"dateFormat":"dd/mm/y",
			"altFormat":"dd/mm/y",
			"shortYearCutoff": 30 
		});



		$('.visittimeinput').mask("99:99",{placeholder:"HH:MM"});
		$('.visitdatepicker').mask("99/99/99",{placeholder:"DD/MM/YY"});


		$("#plannedstartdate,#plannedstarttime").change(function(){
			setVisitDateFromEntry("data-plannedstart",$("#plannedstartdate"),$("#plannedstarttime"));
			if($(currentVisitGrid.getSelectedRow()).attr("data-appointmentstart")!=""){
				createPlannerAppointment();
			}				
		});

		$("#plannedenddate,#plannedendtime").change(function(){
			setVisitDateFromEntry("data-plannedend",$("#plannedenddate"),$("#plannedendtime"));
			if($(currentVisitGrid.getSelectedRow()).attr("data-appointmentstart")!=""){
				createPlannerAppointment();
			}				
		});

		$("#workstartdate,#workstarttime").change(function(){
			setVisitDateFromEntry("data-workstart",$("#workstartdate"),$("#workstarttime"));
		});

		$("#workenddate,#workendtime").change(function(){
			setVisitDateFromEntry("data-workend",$("#workenddate"),$("#workendtime"));
		});

		$("#visitappointmentcreate").click(function(){
			createPlannerAppointment();
		});
		$("#visitappointmentview").click(function(){
			viewPlannerAppointment();
		});		
		tinyAjaxLoad("POST","/partials/maintenance/maintenance_current_visits",{'xidmjob':CURRENT_MJOB},function(data){
			$("#currentvisits").html(data);
			loadCurrentVisitGrid();	
		});	

	});		
	tinyAjaxLoad("POST","/partials/popups/maintenance_engineer_popup",{},function(data){
		$("#visitengineerreassignpopup").html(data);
	});							

									
}

function createPlannerAppointment(){
	if ($(currentVisitGrid.getSelectedRow()).attr("data-plannedstart")!=0 && $(currentVisitGrid.getSelectedRow()).attr("data-plannedend")!=0){
		if ($(currentVisitGrid.getSelectedRow()).attr("data-plannedstart")>=$(currentVisitGrid.getSelectedRow()).attr("data-plannedend")){
			sweetAlert("Create Appointment", "This appointment cannot be created as the start time and end time are the same, or the start time occurs afte the end time", "error");
			$(currentVisitGrid.getSelectedRow()).attr("data-appointmentstart","");
			$(currentVisitGrid.getSelectedRow()).attr("data-appointmentend","");
			$("#visitappointmentcreate").show();
			$("#visitappointmentcreationnotice").hide();
		}else{
			setVisitDateFromEntry("data-appointmentend",$("#plannedenddate"),$("#plannedendtime"));	
			setVisitDateFromEntry("data-appointmentstart",$("#plannedstartdate"),$("#plannedstarttime"));	
			$("#visitappointmentcreate").hide();
			if($(currentVisitGrid.getSelectedRow()).attr("data-appointmentid")==""){
				$("#visitappointmentcreationnotice").show();
			}else{
				$("#visitappointmentview").show();
			}

		}
	}else{
		sweetAlert("Create Appointment", "Appointments are created based on the planned start and end times of your visit. Please check that they have been entered and try again.", "error");
	}	
}

function viewPlannerAppointment(){
	//console.log( (parseInt($(currentVisitGrid.getSelectedRow()).attr("data-appointmentstart"))-1000));
    window.location.href='/planner?timestamp='+ (parseInt($(currentVisitGrid.getSelectedRow()).attr("data-appointmentstart"))-3000);	
}

function getVisitsLists(){
	var visits=[];
	currentVisitGrid.find('tr').each(function(index,item){
		if(typeof($(item).attr("id"))!="undefined"){
			var visit={id:$(item).attr("id"),
					   materialsused:$(item).attr("data-materialsused"),
					   workcarriedout:$(item).attr("data-workcarriedout"),
					   instructions:$(item).attr("data-instructions"),
					   status:$(item).attr("data-status"),
					   name:$(item).children().eq(0).text(),
					   engineerid:$(item).attr("data-engineerid"),
					   plannedstart:$(item).attr("data-plannedstart"),
					   plannedend:$(item).attr("data-plannedend"),
					   workstart:$(item).attr("data-workstart"),
					   workend:$(item).attr("data-workend"),
					   appointmentid:$(item).attr("data-appointmentid"),					   
					   appointmentstart:$(item).attr("data-appointmentstart"),
					   appointmentend:$(item).attr("data-appointmentend"),
					   resourcekey:$(item).attr("data-resourcekey")

			};
			visits.push(visit);
		}

	});

	return visits;
}




function getDeletedVisits(){
	var visits=[];
	currentVisitGrid.find('tr.row_deleted').each(function(index,item){
		if(typeof($(item).attr("id"))!="undefined"){
			if ($(item).attr("id")!="-1"){
				visits.push($(item).attr("id"));
			}

		}

	});

	return visits;	
}