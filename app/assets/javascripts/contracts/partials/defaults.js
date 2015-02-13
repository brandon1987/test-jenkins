$(function() {
	$("#update-defaults-button").click(updateDefaults);
});

function updateDefaults() {
	$("#update-defaults-button").setButtonActive();
	$.ajax({
		type: "PATCH",
		url:  "/contracts/" + CONTRACT_ID + "/defaults",
		data: $("#contract-defaults").serialize(),
		success: function(response) {
			$("#update-defaults-button").setButtonCompleted(response.success);
		}
	});
}