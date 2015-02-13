$(function() {
	$("#customer").change(getNewBranchSelection);
	$("#branch").change(getBranchAddress);
});

function getNewBranchSelection() {
	var newID = $(this).val();

	if (newID > 0) {
		$.ajax({
			type:    "GET",
			url:     "/branch_addresses/for_web_customer/" + newID,
			success: updateBranchSelection
		});
	}
}

function updateBranchSelection(selectionJSON) {
	var branchList = $("#branch");
	branchList.empty();

	$("<option/>").attr("value", -1)
	              .text("Default")
	              .appendTo(branchList);

	for (key in selectionJSON) {
		if (selectionJSON.hasOwnProperty(key)) {
			var val = selectionJSON[key];
			console.log(key + " " + val);
			$("<option/>").attr("value", key)
			              .text(val)
			              .appendTo(branchList);
		}
	}
}

function getBranchAddress() {
	var branchID = $(this).val();

	if (branchID > 0) {
		$.ajax({
			type:    "GET",
			url:     "/branch_addresses/" + branchID,
			success: function(response) {
				var address = "";
				if (response.add1 != "") address += response.add1 + "\n";
				if (response.add2 != "") address += response.add2 + "\n";
				if (response.add3 != "") address += response.add3 + "\n";
				if (response.add4 != "") address += response.add4 + "\n";
				if (response.add5 != "") address += response.add5 + "\n";
				if (response.tel != "")  address += response.tel;
				$("#address").val(address);
			}
		});
	} else if (branchID == -1) {
		updateAddressField();
	}
}