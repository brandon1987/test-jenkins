$(function(){
	setUpSiteAddressDialog();
	$("#site_address").select2();
	$("#site_address").change(checkForNewSiteAddressSelection);
});

function setUpSiteAddressDialog() {
	$("#new-site-address-dlg").dialog({
		width: 'auto',
		modal: 'true',
		autoOpen: false
	});

	$('#save-address-btn').click(saveNewSiteAddress);
}

function checkForNewSiteAddressSelection() {
	var selected = $(this).val();

	if (selected == -2) {
		$("#new-site-address-dlg").dialog("open");
	}
}

function saveNewSiteAddress() {
	var data = $("#address-data-form").serialize();

	$.ajax({
		type:    "POST",
		url:     "/site_addresses",
		data:    $("#address-data-form").serialize(),
		success: onSiteAddressSaved
	});
}

function onSiteAddressSaved(response) {
	if (response.success) {
		$("#new-site-address-dlg").dialog("close");
		var newID = response.new_id;
		var addressName = $("#address_name").val();
		$("<option/>").attr("value", newID)
					.text(addressName)
					.appendTo($("#site_address"));
		$("#site_address").val(newID);
	}
}