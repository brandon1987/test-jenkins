$(function() {
	$("#save-address-btn").click(updateSiteAddress);
});

function updateSiteAddress() {
	var data = $("#address-data-form").serialize();

	$("#save-address-btn").setButtonActive();

	$.ajax({
		type: "PATCH",
		url:  "/site_addresses/" + ADDRESS_ID,
		data: data,
		success: function(response) {
			$("#save-address-btn").setButtonCompleted(response.success);
		}
	})
}