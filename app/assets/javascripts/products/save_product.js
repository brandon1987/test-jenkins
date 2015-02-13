function validateProduct(){
	$.validate({
		language : myLanguage,
		modules : 'uk',
		errorMessagePosition : $messages,
		borderColorOnError : '#c0392b',
		onError : function() {
    	},
    	onSuccess : function() {
      		saveProduct();
      		return false; // Will stop the submission of the form
    	},
    	beforeValidation : function () {
    	}
	});
};

function saveProduct() {
	var url = document.location.href.split("/");
	CURRENT_PRODUCT = url[url.length - 1];

	var data = $("#add-edit-product-form").serialize();

	$("#product-save-button").setButtonActive();

	if (CURRENT_PRODUCT !== 'new') {
		updateProduct(data);
	} else {
		addProduct(data);
	}
}

function addProduct(data) {
	$.ajax({
		type: 'POST',
		url: '/products',
		data: data,
		success: function(newID) {
			document.location = "/products/" + newID;
		}
	});
}

function updateProduct(data) {
	$.ajax({
		type: 'PATCH',
		url: '/products/' + CURRENT_PRODUCT,
		data: data,
		success: function() {
			$("#product-save-button").setButtonSucceeded();
		}
	});
}

$(function(){
	$("#product-save-button").click(validateProduct);
});


