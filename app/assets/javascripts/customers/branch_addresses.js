$(function() {
	$("#new-branch-address-btn").click(newBranchAddressButtonClicked);
	$("#delete-branch-address-btn").click(checkDelete);
	$("#cancel-new-address-btn").click(enableBranchAddressButtons);
	$("#save-address-btn").click(saveOrCreateAddress);
	$("#branch_address_names").click(branchAddressSelected);

	creatingNewAddress = false;
});



function newBranchAddressButtonClicked() {
	disableBranchAddressButtons();
}

function disableBranchAddressButtons() {
	setBranchAddressButtonDisabled(true);
}

function enableBranchAddressButtons() {
	setBranchAddressButtonDisabled(false);
}

function setBranchAddressButtonDisabled(state) {
	creatingNewAddress = state;

	$("#branch_address_names").prop("disabled", state);
	$("#new-branch-address-btn, #delete-branch-address-btn, #import-branch-addresses-btn").prop("disabled", state);
	$("#cancel-new-address-btn").css("display", state ? "inline-block" : "none");
}

function saveOrCreateAddress() {
	if (creatingNewAddress) {
		addNewBranchAddress();
	} else {
		updateSelectedAddress();
	}
}

function addNewBranchAddress() {
	var data = $("#branch-address-form").serialize();

	$.ajax({
		type:    "POST",
		url:     "/branch_addresses",
		data:    $("#branch-address-form").serialize(),
		success: onBranchAddressSaved
	});
}

function onBranchAddressSaved(response) {
	if (response.success) {
		var newID = response.new_id;
		var firstLine = $("#add1").val();
		$("<option/>").attr("value", newID)
					.text(firstLine)
					.appendTo($("#branch_address_names"));
		$("#branch_address_names").val(newID);
		enableBranchAddressButtons();
		$("#save-address-btn").setButtonSucceeded();
	}
}

function checkDelete() {
	var selected = $("#branch_address_names").val();

	if (selected !== null) {
		swal({
			title: "Are you sure?",
			text: "You are about to permanently delete the selected site address.",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Okay",
			closeOnConfirm: true },
			function() {
				deleteBranchAddress(selected);
			});
	}
}

function deleteBranchAddress(id) {
	$.ajax({
		type: "DELETE",
		url:  "/branch_addresses/" + id,
		success: function (response) {
			removeBranchAddressFromList(id);
		}
	})
}

function removeBranchAddressFromList(value) {
	var selectobject=document.getElementById("branch_address_names")
	for (var i=0; i<selectobject.length; i++){
		if (selectobject.options[i].value == value )
			selectobject.remove(i);
	}
}

function updateSelectedAddress() {
	var selected = $("#branch_address_names").val();

	if (selected !== null) {
		var data = $("#branch-address-form").serialize();

		$("#save-address-btn").setButtonActive();

		$.ajax({
			type:    "PATCH",
			url:     "/branch_addresses/" + selected,
			data:    $("#branch-address-form").serialize(),
			success: onBranchAddressUpdated
		});
	}
}

function onBranchAddressUpdated(response) {
	var newVal = $("#add1").val();
	var value = $("#branch_address_names").val();

	if (response.success) {
		var selectobject=document.getElementById("branch_address_names")
		for (var i=0; i<selectobject.length; i++){
			if (selectobject.options[i].value == value )
				selectobject.options[i].innerHTML = newVal;
		}

		$("#save-address-btn").setButtonSucceeded();
	}
}

function branchAddressSelected() {
	var selected = $(this).val();

	$.ajax({
		type:    "GET",
		url:     "/branch_addresses/" + selected + ".json",
		success: function(addressJson) {
			for(key in addressJson) {
				if (addressJson.hasOwnProperty(key)) {
					$("[name='branch[" + key + "]']").val(addressJson[key]);
				}
			}
		}
	});
}