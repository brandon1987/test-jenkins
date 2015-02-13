//= require settings/defaults

inviteEmailOverridden=false;

$(function(){
	$('#settings-tabs').tabs();
	$("#defaults-tabs").tabs();
	$("#settings-tabs").tabs({
		activate:function(event,ui){
			switch($("#settings-tabs").tabs("option","active")){
				case 4:

					clientportalCustomersGrid.adjustGridAndToggleSize();
				default:
			}
		}
	});
	$("#options-header span").click(function(){
		var section = $(this).attr("data-section");

		$(".text-section").not("#options-header").not("#"+section).slideUp();

		if($("#"+section).css("display") === "none") {
			$("#"+section).slideDown();
		}
	});

	$(".email-template-save-button").click(saveTemplates);

	$('#test-connection-button').click(testDatabaseConnection);
	$('#save-connection-button').click(saveDatabaseConnection);

	$("#test-integration-url-button").click(testSageIntegrationConnection);
	$("#save-integration-url-button").click(saveSageIntegrationConnection);

	$('#update-password-button').click(updatePassword);
	$("#new_password, #confirm_new_password").keyup(checkPasswordMatch);

	setUpAddUserDialog();
	$("#add-user-dialog-open-button").click(function(){
		$("#new-user-email").val("");
		$("#new-user-dialog").dialog("open");
	});
	$("#add-user-button").click(addUser);

	$(".user-delete-button").click(function(){
		var userID = $(this).attr("data-userid");
		deleteUser(userID);
	});

	$("#invite-list").on("click", ".invite-revoke-button", function(){
		var inviteID = $(this).attr("data-inviteid");
		revokeInvite(inviteID);
	});


	$(".notification_opt_in").on("ifChanged",function(){
		saveNotificationSetting($(this).attr("name"),$(this).is(':checked'));
	});

	$(".notification_opt_in").on("ifChecked",function(){
		$(".notification_opt_in_priority[name='"+$(this).attr("name")+"']").select2("enable", true);
	});	
	$(".notification_opt_in").on("ifUnchecked",function(){
		$(".notification_opt_in_priority[name='"+$(this).attr("name")+"']").select2("enable", false);
	});	

	$(".notification_opt_in_priority").on("change",function(){
		saveNotificationPriority($(this).attr("name"),$(this).val());
	});

	$("#customerportalsavebutton").click(function(){
		saveClientPortalOptions();
	});

	$(".notification_opt_in_priority").select2();

	setClientPortalTable();
});
function saveNotificationPriority(name,priority){
	$.ajax({
		type: 'POST',
		url: '/settings/save_notification_priority',
		data: {"name": name,
			   "priority":priority
		},
		success: function(response) {
		}

	});	
}

function saveNotificationSetting(name,setting){
	$.ajax({
		type: 'POST',
		url: '/settings/save_notification_opt_in',
		data: {"name": name,
			   "setting":setting
		},
		success: function(response) {
		}

	});
}

function saveClientPortalOptions(){
	$("#customerportalsavebutton").setButtonActive();
	$.ajax({
		type: 'POST',
		url: '/settings/set_clientportal_options',
		data: {"clientportalname": $("#clientportalname").val()
		},
		success: function(response) {
			if (response=="inuse"){
				sweetAlert("Sorry", "This company name is already in use and could not be saved. Please select a different name and try again.", "error");
				$("#customerportalsavebutton").setButtonFailed();
			}else{
				$("#customerportalsavebutton").setButtonSucceeded();
				$("#clientportalname").attr("value",$("#clientportalname").val());
			}
		}

	});

}


function setClientPortalSetting(customerid,section,settingvalue){
var emailAddress="";
	$.ajax({
		type: 'POST',
		url: '/settings/set_clientportal_settings',
		data: {"customerid": customerid,
			   "section": section,
			   "settingvalue": settingvalue
		},
		success: function(response) {
		}

	});


}

function sendInviteEmail(customerId,emailAddress){
	//check to see if the customer record has a valid email address, if so, then send. if not then prompt for one.
			getValidEmailAddress(emailAddress,customerId);
}

function sendInviteEmailConfirmed(customerId,emailAddress){
	//we are sure that the email address is good now, so send the email!

	$.ajax({
		type: 'POST',
		url: '/settings/send_clientportal_password_email',
		data: {'emailaddress': emailAddress,
			   'customerid':customerId},
		success: function(response) {
			swal("Email Sent", "A clientportal invitation has been sent to your customer", "success");
		}
	});
}

function getValidEmailAddress(defaultaddress,customerId){

	//prompt for a valid email address then check if it is valid. if it is valid then we call the sendinviteemail method again with an override email
	inputDialog({dialoglabel:"Please confirm the email address the invitation should be sent to",
	 	inputlabels:["Email Address"],
	 	defaults:[defaultaddress]
		},function done(isConfirmed,formdata){
			if(isConfirmed){
				$.ajax({
					type: 'GET',
					url: '/email_validate_address',
					data: {"email": formdata[0]['value']
					},
					success: function(response) {
						if(response=='true'){

							sendInviteEmailConfirmed(customerId,formdata[0]['value']);
							//sendInviteEmail(customerId,formdata[0]['value']);
						}else{
							getValidEmailAddress(defaultaddress,customerId);
						}

					}
				});//ajax						
			}
		}
	);//inputdia
}

function setUpAddUserDialog() {
	$('#new-user-dialog').dialog({
		width: 'auto',
		modal: 'true',
		autoOpen: false
	});
}

function addUser() {
	$("#add-user-button").setButtonActive();
	var address = $("#new-user-email").val();
	$.ajax({
		type: 'POST',
		url: '/mail/send_invite_link',
		data: {address: address},
		success: function(response) {
			if (response.status == 0) {
				$("#add-user-button").setButtonSucceeded();
				addInviteToList(response.new_invite_id);
				$("#new-user-dialog").dialog("close");
			} else {
				$("#add-user-button").setButtonFailed(response.message);
			}
		},
		dataType: 'json'
	});
}

function deleteUser(userID) {
	$.ajax({
		type: 'DELETE',
		url: '/users/' + userID,
		success: function(response) {
			$("[data-userid='" + userID + "']").parents("tr").remove();
			resetUserListRowClasses();
		}
	});	
}

function revokeInvite(inviteID) {
	$.ajax({
		type: 'DELETE',
		url: '/settings/revoke_invite/' + inviteID,
		success: function(response) {
			$("[data-inviteid='" + inviteID + "']").parents("tr").remove();
			resetInviteListRowClasses();
		}
	});
}

function addInviteToList(inviteID) {
	$("#invite-list tr:contains('" +$("#new-user-email").val()  + "')").remove();

	var newRowHtml = "<tr>";
	newRowHtml    += "<td>" + $("#new-user-email").val() + "</td>";
	newRowHtml    += '<td class="button-column delete-button" style="padding: 0px;">';
	newRowHtml    += '<button class="invite-revoke-button" ';
	newRowHtml    += ' data-inviteid="' + inviteID + '">Revoke</button>';
	newRowHtml    += "</td></tr>"

	$("#invite-list").append(newRowHtml);
	resetInviteListRowClasses();
}

function saveTemplates() {
	var templateData = $(".email-template-save-button").parent().serialize();
	$(".email-template-save-button").setButtonActive();

	$.ajax({
		type: 'POST',
		url: '/settings/save_email_templates',
		data: templateData,
		success: function(response) {
			$(".email-template-save-button").setButtonSucceeded();
		},
		dataType: 'json'
	});
}

function testDatabaseConnection() {
	var button = $(this);
	button.setButtonActive();
	$.ajax({
		type: 'POST',
		url: '/settings/check_db_connection',
		data: {
			hostname: $('#hostname').val(),
			database: $('#database').val(),
			port:     $('#port').val(),
			username: $('#username').val(),
			password: $('#password').val()
		},
		success: function(response) {
			if (response.error == undefined) {
				button.setButtonSucceeded();
			} else {
				button.setButtonFailed("Connection Failed");
			}
		},
		error: function() {
			button.setButtonFailed("Connection Failed");
		},
		dataType: 'json'
	});			
}

function saveDatabaseConnection() {
	var button = $(this);
	button.setButtonActive();
	$.ajax({
		type: 'POST',
		url: '/settings/save_db_connection',
		data: {
			hostname: $('#hostname').val(),
			database: $('#database').val(),
			port:     $('#port').val(),
			username: $('#username').val(),
			password: $('#password').val()
		},
		success: function() {
			button.setButtonSucceeded();
		}
	});
}

function testSageIntegrationConnection() {
	var button = $(this);
	button.setButtonActive();

	$.ajax({
		type: 'POST',
		url: "/settings/test_sage_connection",
		data: {
			address:  $("#integration-url").val(),
			password: $("#integration-password").val()
		},
		success: function(r) {
			if (r.success) {
				button.setButtonSucceeded();
			} else {
				button.setButtonFailed();
			}
		},
		error: function(e) {
			console.log(e);
			button.setButtonFailed();
		}
	});			
}

function saveSageIntegrationConnection() {
	var button = $(this);
	button.setButtonActive();

	var address = $("#integration-url").val();
	var password = $("#integration-password").val();

	$.ajax({
		type: 'POST',
		url: '/settings/save_sage_connection',
		data: {
			address: address,
			password: password
		},
		success: function() {
			button.setButtonSucceeded();
		}
	});
}

function checkPasswordMatch() {
	var newPW = $("#new_password").val();
	var confirmNewPW = $("#confirm_new_password").val();

	if (newPW != confirmNewPW) {
		$("#password-change-message").css("display","inline-block");
		$("#password-change-message").removeClass("success-message");
		$("#password-change-message").addClass("error-message");
	} else {
		$("#password-change-message").css("display","none");
		$("#password-change-message").removeClass("error-message");
	}
}

function updatePassword() {
	var newPW = $("#new_password").val();
	var confirmNewPW = $("#confirm_new_password").val();

	if (newPW != confirmNewPW) {
		$("#password-change-message").animate({
			color: "#f00",
			borderColor: "#f00"
		}, 250, function() {
			$("#password-change-message").animate({
				color: "#B33C3C",
				borderColor: "#B33C3C"
			}, 250 );
		});
	} else {
		$.ajax({
			type: "POST",
			url: "/settings/update_password",
			data: {
				old_password:     $("#old_password").val(),
				new_password:     $("#new_password").val(),
				confirm_password: $("#confirm_new_password").val()
			},
			success: function(response) {
				if (response.status !== undefined && response.status == 0) {
					$("#password-change-message").text("Your password has been successfully updated.");
					$("#password-change-message").css("display","inline-block");
					$("#password-change-message").removeClass("error-message");
					$("#password-change-message").addClass("success-message");
				}
			},
			dataType: "json"
		});
	}
}

function resetUserListRowClasses() {
	$("#user-list").find(".even").removeClass(".even");
	$("#user-list").find("tr:odd").each(function(){
		$(this).addClass("even");
	});
}

function resetInviteListRowClasses() {
	$("#invite-list").find(".even").removeClass(".even");
	$("#invite-list").find("tr:odd").each(function(){
		$(this).addClass("even");
	});
}

$(document).ready(function(){
	$("#settings").addClass("menuActive");

});

$(document).ready(function(){
	$('button.user-delete-button, button.invite-revoke-button').hover(function() {
		$(this).parent().parent().addClass("soft-red-background");
  	}, function() {
    // on mouseout, reset the background colour
    	$(this).parent().parent().removeClass("soft-red-background");
  	});
});

$(function() {
	$("[name^=company_preferences]").change(updateCompanyPreference);
	$('[name^=company_preferences]').on('ifToggled', updateCompanyPreference);
	$("#quote-status-select").select2({tags: []});
})

function formatselect(item) { return item.text; }
function formatdisplay(item) { return item.text; }

function updateCompanyPreference() {
	var input = $(this);
	var name = input.attr("name");
	var value;
	if (input.is(":checkbox")) {
		value = input.is(":checked") ? true : false;
	} else {
		value = input.val();
	}
	var data = {};
	data[name] = value;
	$.ajax({
		type: "PATCH",
		url: "/company_preferences",
		data: data,
		success: function(response) {
		}
	})
}


function setClientPortalTable(){



	ajaxUrl="/settings/clientportal_customer_gridajaxdata";
    GRID_NAME='settings_clientportal_customers'

	clientportalCustomersGrid = $('#clientportalcustomerslist').dataTable( {
        "aoColumnDefs": [
        

            { "sClass": "caligncol",  "aTargets": [ 1,2,3] }            
        ],
    
    	serverSide: true,
   		sServerMethod:'POST',
		ajax:{
		    "url": ajaxUrl,
		    "type": "POST",
		    "data": {'gridname':GRID_NAME}
		    },	
		"deferLoading": 0,		    
		"bPaginate": true,
		"sPaginationType": "full_numbers",
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"pageLength":50,
		"bInfo": false,
		"bAutoWidth": true,
		"scrollX": true,
		"sScrollY" :400
 
	});

	clientportalCustomersGrid.on("xhr.dt", function( e, settings, data ){
		$.each(data['data'],function(index,value){

			data.data[index][1]= "<div style='width:250px;text-align:center;margin-left:auto;margin-right:auto'><div class='clientportalsectionenable maintenancesettingbutton' style='margin-right:5px'><input type='checkbox' class='clientportaltick' section='is_portal_maintenance' "+ (data.data[index][1] ? "checked" : "") +">&nbsp&nbspEnable</div><div class='maintenancesettingbutton clientportalmaintenanceconfig' section='is_portal_maintenance'><span class='fa fa-gear'></span>&nbsp&nbspConfigure</div></div>"
			data.data[index][2]= "<div style='width:250px;text-align:center;margin-left:auto;margin-right:auto'><div class='clientportalsectionenable maintenancesettingbutton' style='margin-right:5px'><input type='checkbox' class='clientportaltick' section='is_portal_maintenancetasks' "+ (data.data[index][2] ? "checked" : "") +">&nbsp&nbspEnable</div><div class='maintenancesettingbutton clientportalmaintenanceconfig' section='is_portal_maintenancetasks'><span class='fa fa-gear'></span>&nbsp&nbspConfigure</div></div>"
			data.data[index][3]= "<div class='maintenancesettingbutton clientportalinvitebutton' style='margin-right:5px'>Send Invite</div><div class='maintenancesettingbutton clientportaltestbutton'>Test</div>"

		});
	});

	clientportalCustomersGrid.on("draw.dt",function(){
		
			$(".clientportaltick").iCheck({
				checkboxClass: 'icheckbox_flat-blue',
				radioClass: 'iradio_flat-blue'
			});						

			$('.clientportaltick').on('ifChanged', function(event){
				setClientPortalSetting($(this).closest("[role='row']").attr("id").replace("settings_clientportal_customers_",""),$(this).attr("section"),$(this).is(':checked'));
			});

			$(".clientportalmaintenanceconfig").click(function(){
				configureClientPortalSection($(this).closest("[role='row']").attr("id").replace("settings_clientportal_customers_",""),$(this).attr("section"));
			});


			$(".clientportalsectionenable").click(function(){
				$(this).find(".clientportaltick").iCheck('toggle');
			});

			$(this).find("td:not(:first-child)").attr("notip","true");
	

			$(".clientportalinvitebutton").click(function(){

				if ($("#clientportalname").attr("value")!=""){
					inviteEmailOverridden=false;
					sendInviteEmail($(this).closest("[role='row']").attr("id").replace("settings_clientportal_customers_",""),$(this).closest("[role='row']").attr("clientportal-email"));			
				}else{
					sweetAlert("Sorry", "Sorry, you must first set your company ref before sending clientportal invites to your customers.", "error");			
				}

			});

			$(".clientportaltestbutton").click(function(){
				var customerid=$(this).closest("[role='row']").attr("id").replace("settings_clientportal_customers_","");
				swal({
				  title: "Portal Test",
				  text: "This option will allow you to see the client portal as your customer will see it. It will cause you to be logged out of ConstructionManager.Net for the duration of the test.",
				  type: "warning",
				  showCancelButton: true,
				  confirmButtonColor: "#DD6B55",
				  confirmButtonText: "Continue",
				  closeOnConfirm: true
				},

				function(){
					
					$.ajax({
						type: 'GET',
						url: '/settings/converttoclientportalsession' ,
						data: {'customerid':customerid},
						success: function(response) {
							if (response=="true"){
								window.location.href='/clientportal/home';
							}else{
								window.location.href='/';
							}
						}
					});	

				});

			});			

			clientportalCustomersGrid.getHead().find(".text_filter").not(':first').attr('disabled', true);

		
	});


	clientportalCustomersGrid.columnFilters();
	clientportalCustomersGrid.totalsRow('');
	clientportalCustomersGrid.enableColumnToggling({'grid_name':GRID_NAME,'hidebutton':true});	
	clientportalCustomersGrid.adjustGridAndToggleSize();


}

function configureClientPortalSection(customerid,section){

	tinyAjaxLoad("POST","/partials/settings/clientportalhiddencolumnsgrid", {'customerid':customerid,'section':section},function(data){

	    	$("#clientportalhiddencolumnstable").find("tbody").html(data)
			$(".clientportalhiddencolumncheck").iCheck({
					checkboxClass: 'icheckbox_flat-blue',
					radioClass: 'iradio_flat-blue'
			});		
			$("#clientportalhiddencoldialogclose").click(function(){
				$("#clientportalhiddencolumnsdialog").dialog("close");
			});
			$(".clientportalhiddencolumncheck").on("ifToggled",function(){
				$.ajax({
					type: 'get',
					url: '/clientportal_hidden_columns/settingchange',
					data: {"section": section,"customerid":customerid,"column":$(this).attr("column"),"setting":$(this).is(':checked'),"columnselector":$(this).attr("columnselector")},
					success: function(response) {}

				});				
			});

	    	$("#clientportalhiddencolumnsdialog").dialog({maxHeight:600,minWidth:450,title:"Clientportal Hidden Columns"});
	});





	

}