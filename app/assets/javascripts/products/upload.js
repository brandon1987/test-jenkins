$(function(){
	$('#stock-import-button').on('click',function() {
		$('#products-import-dialog').dialog( 'open' );
	});

	$("#sage-import-button").click(uploadFromSage);
});

function postProductCSV(formData) {
	$("#confirm-upload-button").setButtonActive();
	$.ajax({
		type:        'POST',
		url:         '/products/upload_stock_file',
		data:        formData,
		contentType: false,
		processData: false,
		success: function() {
			document.location = "/products";
		},
		error: function() {
			$("#confirm-upload-button").setButtonFailed();
		}
	});
}

function uploadFromSage() {
	swal("Importing Products", "Please wait.");
	$.ajax({
		type: 'POST',
		url: '/products/import_from_sage',
		success: function() {
			document.location = "/products";
		}
	});
}