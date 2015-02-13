function saveMJob() {
	var bvalid=false;
	var saveproblems=[];
	if($("#popup_siteaddress").val()==""){
		saveproblems.push("A site address is required");
	}
	if($("#popup_contract").val()==""){
		saveproblems.push("A contract is required");
	}
	if($("#popup_customer").val()==""){
		saveproblems.push("A customer is required");
	}
	if (saveproblems.length==0){
		bvalid=true;
	}else{
		var errorstring="<br>";
		$.each(saveproblems, function( index, value ) {
			errorstring+=value+"<br>";
		});
		sweetAlert({html:true,title:"Maintenance Save",text:"Your maintenance job could not be saved for the following reason(s):"+errorstring, type:"error"});
	}

	if (bvalid){
		var data = {
			id:undefined,
			xid_site_address: $("#popup_siteaddress").val(),
			xid_contract: $("#popup_contract").val(),
			xid_customer_ref: $("#popup_customer").val(),
			xid_priority: $("#popup_priority").val(),
			status: $("#popup_mjobstatus").val(),
			xid_project_manager: $("#popup_projectmanager").val(),
			xid_schedule: $("#-1").val(), 								//future use
			xid_customer_branch: $("#popup_customerbranchaddress").val(),
			inception_datetime: getDateTimeString($("#createddate").val(),$("#createdtime").val()),
			begin_datetime:  getDateTimeString($("#startdate").val(),$("#starttime").val()),
			completion_datetime: getDateTimeString($("#completeddate").val(),$("#completedtime").val()),
			planned_completion_datetime: getDateTimeString($("#plannedcompletiondate").val(),$("#plannedcompletiontime").val()),
			datetimestamp: getTimeStamp(),
			ref_1: $("#mjob").val(),
			ref_2: "",
			ref_3: "",
			long_description: $("#longdescription").val(),
			work_description: $("#workdescription").val().replace(/\n/g, ""),
			order_value: $("#mjobvalue").val(),
			manager_name: $("#popup_projectmanager").val(),
			schedule_name: "",
			username: "",
			work_carried_out: $("#workcarriedout").val(),
			is_quote: $("#mjobsalestype").val()==1?-1:0,
			is_schedule: $('#mjobsalestype').val()==2?-1:0,
			is_product_invoice: $('#mjobsalestype').val()==3?-1:0,
			labour_markup: $("#labourmarkup").val(),
			material_markup: $("#materialsmarkup").val(),
			sub_markup: $("#subcontractormarkup").val(),
			stock_markup: $("#stockmarkup").val(),
			po_markup: $("#pomarkup").val(),
			visits:JSON.stringify(getVisitsLists()),
			deletedvisits:JSON.stringify(getDeletedVisits()),
			reassignedvisits:JSON.stringify(getReassignedVisits()),
			completingvisits:JSON.stringify(completingvisits)
		};
		for(i=0;i<customFieldIds.length;i++){  //loop through our custom fields and pick up the values from the form.
			data["CustomField"+customFieldIds[i]]= $("#customfield"+customFieldIds[i]).val();
		}


		//replace any invalid values with correct ones before proceeding
		data.xid_site_address=="" && (data.xid_site_address=-1);
		//data.xid_created_from_repetition==null && (data.xid_created_from_repetition=-1);
		data.xid_contract==""  && (data.xid_contract=-1);
		data.xid_customer_ref==""  && (data.xid_customer_ref=-1);
		data.xid_priority==""  && (data.xid_priority=-1);
		data.status==""  && (data.status=-1);
		data.xid_schedule==""  && (data.xid_schedule=-1);
		data.xid_customer_branch==""  && (data.xid_customer_branch=-1);
		data.xid_project_manager==""  && (data.xid_project_manager=-1);

		data.inception_datetime.trim()=="" && (data.inception_datetime="1899-12-30 00:00:00");
		data.begin_datetime.trim()=="" && (data.begin_datetime="1899-12-30 00:00:00");
		data.completion_datetime.trim()=="" && (data.completion_datetime="1899-12-30 00:00:00");
		data.planned_completion_datetime.trim()=="" && (data.planned_completion_datetime="1899-12-30 00:00:00");



		$("#mjob_save_button").setButtonActive();


		if (CURRENT_MJOB != -1) {
			data.id = CURRENT_MJOB;
			updateMJob(data);
		} else {
			addMJob(data);
		}
		if (completingvisits!=[]){
			websocket.emit('notification_reload', COMPANY_ID);
		}
	}
}

function getDateTimeString(datecomponent,timecomponent){
	if(datecomponent==""){
		return "1899-12-30 00:00:00"
	}else{
		return datecomponent+" "+timecomponent
	}
}

function addMJob(data) {
	$.ajax({
		type: 'POST',
		url:  '/maintenance',
		data: data,
		success: function(returndata) {

			if (returndata.success==true){
				document.location = "/maintenance/" + returndata.id;
				$("#mjob_save_button").setButtonSucceeded();	
				$("#mjob").val(returndata.ref_1)	;	
	            websocket.emit('mjob_reload', COMPANY_ID);	
				websocket.emit('redraw_planner', COMPANY_ID);	            
	            if (returndata.appointmentsave==false){
					sweetAlert("Appointment Save", "One or more of your appointments could not be saved due to a clash with an existing appointment, please check that a time slot is available and try again.", "error");
				}
				reloadVisitsList();	  

			}else{
				$("#mjob_save_button").setButtonFailed();
			}
			reloadAttachedFilesDirectoryTree();     
		}
	});
}

function updateMJob(data) {
	$.ajax({
		type: 'PATCH',
		url:  '/maintenance/' + data.id,
		data: data,
		success: function(returndata) {
			if (returndata.success==true){
				$("#mjob_save_button").setButtonSucceeded();
	            websocket.emit('mjob_reload', COMPANY_ID);
				websocket.emit('redraw_planner', COMPANY_ID);	            
				reloadVisitsList();	   
				         				
			}else{
				$("#mjob_save_button").setButtonFailed();
			}
		}
	});
}

function getTimeStamp() {
       var now = new Date();
       return ((now.getMonth() + 1) + '/' + (now.getDate()) + '/' + now.getFullYear() + " " + now.getHours() + ':'
                     + ((now.getMinutes() < 10) ? ("0" + now.getMinutes()) : (now.getMinutes())) + ':' + ((now.getSeconds() < 10) ? ("0" + now
                     .getSeconds()) : (now.getSeconds())));
}