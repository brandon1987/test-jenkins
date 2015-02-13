$(function() {
	$("#save-address-btn").click(updateSiteAddress);
});

function updateSiteAddress() {
	var data = $("#address-data-form").serialize();

	$("#save-address-btn").setButtonActive();

	$.ajax({
		type: "POST",
		url:  "/site_addresses",
		data: data,
		success: function(response) {
			$("#save-address-btn").setButtonCompleted(response.success);
			document.location = "/site_addresses/" + response.new_id;
		}
	})
}