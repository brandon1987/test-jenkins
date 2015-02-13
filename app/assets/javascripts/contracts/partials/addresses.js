$(function() {
	$("#address_list").change(siteAddressSelected);
	$("#new-address-button").click(addNewAddress);
	$("#save-address-button").click(saveAddress);
	$('#delete-address-button').click(checkAddressDelete);
	$("#import-address-button").click(openAddressImportDialog);

	configureAddressImportDialog();
});

function siteAddressSelected() {
	$.ajax({
		type:    "GET",
		url:     "/site_addresses/" + $("#address_list").val() + ".json",
		success: function(data) {
			$("#address_name").val(data.tblAddresses_Name)
			$("#address").val(data.tblAddresses_Add1)
			$("#address_2").val(data.tblAddresses_Add2)
			$("#town").val(data.tblAddresses_Add3)
			$("#county").val(data.tblAddresses_Add4)
			$("#postcode").val(data.tblAddresses_Add5)
			$("#contact").val(data.tblAddresses_Contact)
			$("#descrip").val(data.tblAddresses_Description)
			$("#email").val(data.tblAddresses_Email)
			$("#fax").val(data.tblAddresses_Fax)
			$("#homephone").val(data.tblAddresses_HomePhone)
			$("#mobile").val(data.tblAddresses_MobilePhone)
			$("#address_ref").val(data.tblAddresses_Ref)
			$("#tel").val(data.tblAddresses_Tel)
			$("#workphone").val(data.tblAddresses_WorkPhone)
			$("#analysis1").val(data.tbladdresses_Analysis1)
			$("#analysis2").val(data.tbladdresses_Analysis2)
			$("#analysis3").val(data.tbladdresses_Analysis3)
		}
	});
}

function addNewAddress() {
	clearSiteAddressDetails();

	$.ajax({
		type: 'POST',
		url: '/site_addresses/for_contract/' + CONTRACT_ID,
		success: function(newID) {
			if (newID != -1) {
				$('#add-address-button').setButtonSucceeded();

				$("<option/>").attr("value", newID)
					.text("New address")
					.appendTo("#address_list")
					.prop("selected", true);
			} else {
				$('#add-address-button').setButtonFailed();
			}
		},
		error: function() {
			$('#add-address-button').setButtonFailed();
		}
	});
}

function checkAddressDelete() {
	if ($("#address_list").val() == null) return;

	var button = $('#delete-address-button');

	if(button.attr('data-confirmdelete') === "1") {
		button.text('Delete');
		button.attr('data-confirmdelete', 0 );
		button.removeClass('button-toggled-on');
		deleteAddress();
		clearSiteAddressDetails();
	} else {
		button.text('Confirm Delete');
		button.attr('data-confirmdelete', 1 );
		button.addClass('button-toggled-on');
	}
}

function deleteAddress() {
	$('#delete-address-button').setButtonActive();
	var id = $("#address_list").val();

	$.ajax({
		type: 'DELETE',
		url: '/site_addresses/' + id,
		success: function(response) {
			if (response.success) {
				$('#delete-address-button').setButtonSucceeded();
				$("#address_list [value=" + id + "]").remove();
			} else {
				$('#delete-address-button').setButtonFailed();
			}
		},
		error: function() {
			$('#delete-address-button').setButtonFailed();
		}
	});
}

function clearSiteAddressDetails() {
	$("#address_name, #address, #address_2, #town, #county, #postcode").val("");
	$("#contact, #descrip, #email, #fax, #homephone, #mobile").val("");
	$("#address_ref, #tel, #workphone, #analysis1, #analysis2, #analysis3").val("");
}

function saveAddress() {
	$('#save-address-button').setButtonActive();
	var id = $("#address_list").val();

	$.ajax({
		type: 'PATCH',
		url: '/site_addresses/' + id,
		data: $("#address-data-form").serialize(),
		success: function(response) {
			if (response.success) {
				$('#save-address-button').setButtonSucceeded();
				$("#address_list [value=" + id + "]").text($("#address_name").val());
			} else {
				$('#save-address-button').setButtonFailed();
			}
		},
		error: function() {
			$('#save-address-button').setButtonFailed();
		}
	});
}

function configureAddressImportDialog() {
	$('#import-address-dialog').dialog({
		width: '400px',
		modal: 'true',
		autoOpen: false,
		resizable: false
	});
}

function openAddressImportDialog() {
	$("#addresses-import-dialog").dialog("open");
}

function postAddressImportCSV(formData) {
	$("#confirm-upload-button").setButtonActive();
	$.ajax({
		type:        'POST',
		url:         '/contracts/' + CONTRACT_ID + '/import_site_addresses',
		data:        formData,
		contentType: false,
		processData: false,
		success: function(response) {
			repopulateSiteAddressList();
			$("#addresses-import-dialog").dialog("close");
			$("#column-checklist-dialog").dialog("close");
		},
		error: function() {
			$("#confirm-upload-button").setButtonFailed();
		}
	});
}

function repopulateSiteAddressList() {
	$.ajax({
		type:    'GET',
		url:     '/contracts/' + CONTRACT_ID + '/site_addresses',
		success: function(response) {
			$("#address_list").empty();
			for(i in response) {
				var item = response[i];
				$("<option>")
					.val(item.tblAddresses_ID)
					.text(item.tblAddresses_Name)
					.appendTo($("#address_list"))
			}
		}
	});
}