function validateCustomer(){
	$.validate({
		language : myLanguage,
		modules : 'uk',
		errorMessagePosition : $messages,
		onError : function() {
		},
		onSuccess : function() {
			saveCustomer();
			return false; // Will stop the submission of the form
		},
		beforeValidation : function () {},
		validation : function(){}
	});
};

function saveCustomer() {
	var url = document.location.href.split("/");
	CURRENT_CUSTOMER = url[url.length - 1];

	var data = $("#customer-details-form").serialize();

	$("#customer-save-button").setButtonActive();

	if (CURRENT_CUSTOMER !== 'new') {
		data += "&=id" + CURRENT_CUSTOMER;
		updateCustomer(data);
	} else {
		addCustomer(data);
	}
}

function addCustomer(data) {
	$.ajax({
		type: 'POST',
		url: '/customers',
		data: data,
		success: function(response) {
			if (response.success) {
				document.location = "/customers/" + response.new_id;
			} else {
				swal("Error", "The customer could not be saved.", "error");
				$("#customer-save-button").setButtonFailed();
			}
		}
	});
}

function updateCustomer(data) {
	$.ajax({
		type: 'PATCH',
		url: '/customers/' + CURRENT_CUSTOMER,
		data: data,
		success: function() {
			$("#customer-save-button").setButtonSucceeded();
		}
	});
}

$(document).ready(function(){
	$("#customer-save-button").click(validateCustomer);
});