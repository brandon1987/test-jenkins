$(document).ready(function(){
	var heightConst=810;	
	if ($(".clientportal-registration-box").css("display")=='none'){
		heightConst=550;
		console.log("smaller");
	}


	$("#clientportal-register-button").click(function(){
	
		$("#clientportal-error-message-wrapper").css("visibility","hidden");

		if ($("#clientportal-password").val()=="") {
			showError("  Your password cannot be blank. Please enter one and try again.");			
		}else if ($("#clientportal-password").val()!=$("#clientportal-repeat-password").val()){

			showError("  Your passwords do not match, please check and try again.");
		}else{
			$.ajax({
				type: 'get',
				url: '/clientportal/register',
				data: {username: $("#clientportal-username").val(),
	      			   password: $("#clientportal-password").val(),
	      			   invite: $("#clientportal-invite").val()
				},
				success: function(data) {
					if(data!="ok"){
						showError(data)
					}else{
						swal({title:"Registration Complete",
							text: "You have sucessfully completed your registration, you will be forwarded to the log in page for the client portal. You have been sent an email confirming your login details.",
							 type:"success",
							 closeOnConfirm: false
						 },	 function (isconfirm){
							 	window.location.href="/clientportal";
						 });
					}
				}
			}); 			
		}


	});

	var targetheight=0


	$(".expandingsection").css("height",$( window ).height()-heightConst);

	function showError(errormessage){
		$("#clientportal-error-message-wrapper").css("visibility","visible");
		$("#clientportal-error-message-wrapper").html(errormessage);
		
	}

});