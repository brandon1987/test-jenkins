function setAppointmentDialogPermissions() {
	$("#buttonsave, #buttondelete").prop("disabled", !CAN_EDIT);
	$("#buttondelete").prop("disabled", !CAN_DELETE);
}

function resetAppointmentDialogPermissions() {
	$("#buttonsave, #buttondelete").prop("disabled", false);
}