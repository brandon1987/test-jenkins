$(document).ready(function(){

	$("#log-in-button").click(function(){
	  $('#log-in-button').setButtonActive();
	  $.ajax({
	    type: 'GET',
	    url: '/clientportal/login',
	    data: {
	      company: $("#company").val(),
	      username: $("#username").val(),
	      password: $("#password").val()
	    },
	    success: function(response) {
	      if( response.success==false ) {
	        $('#log-in-button').setButtonFailed("Invalid username or password");
	      }else{
	      	window.location.href='/clientportal/home';
	      }

	    },dataType: 'json'
	  });
	});


});



