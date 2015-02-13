//= require_tree ./jqueryplugins

//Form validations (src="//cdnjs.cloudflare.com/ajax/libs/jquery-form-validator/2.1.47/jquery.form-validator.min.js")
var myLanguage = {
      errorTitle : 'Form submission failed!',
      requiredFields : 'You have not answered all required fields',
      badTime : 'You have not given a correct time',
      badEmail : 'Invalid email',
      badTelephone : 'You have not given a correct phone number',
      badSecurityAnswer : 'You have not given a correct answer to the security question',
      badDate : 'You have not given a correct date',
      lengthBadStart : 'You must give an answer between ',
      lengthBadEnd : ' characters',
      lengthTooLongStart : 'You have given an answer longer than ',
      lengthTooShortStart : 'You have given an answer shorter than ',
      notConfirmed : 'Values could not be confirmed',
      badDomain : 'Incorrect domain value',
      badUrl : 'The answer you gave was not a correct URL',
      badCustomVal : 'You gave an incorrect answer',
      badInt : 'The answer you gave was not a correct number',
      badSecurityNumber : 'Your social security number was incorrect',
      badUKVatAnswer : 'Incorrect UK VAT Number',
      badStrength : 'The password isn\'t strong enough',
      badNumberOfSelectedOptionsStart : 'You have to choose at least ',
      badNumberOfSelectedOptionsEnd : ' answers',
      badAlphaNumeric : 'The answer you gave must contain only alphanumeric characters ',
      badAlphaNumericExtra: ' and ',
      wrongFileSize : 'The file you are trying to upload is too large',
      wrongFileType : 'The file you are trying to upload is of wrong type',
      groupCheckedRangeStart : 'Please choose between ',
      groupCheckedTooFewStart : 'Please choose at least ',
      groupCheckedTooManyStart : 'Please choose a maximum of ',
      groupCheckedEnd : ' item(s)'
    };

$(document).ready(function(){
	$messages = $('#error-message-wrapper');
	$.validate({
		language: myLanguage,
		modules : 'uk',
		borderColorOnError : '#B33C3C',
		errorMessagePosition : $messages,
		validation : function() {
    	}
	});
});

function removeRepeated(){
	var divErrMsg = $('#error-message-wrapper').children();
		if (divErrMsg.length > 0){
			for (var i=0; i < divErrMsg.length; i++) {
				currentText = divErrMsg.eq( i ).text();
				for (var j=i+1; j < divErrMsg.length; j++) {
					candidateText = divErrMsg.eq(j).text();
				  if(currentText == candidateText){
				  	divErrMsg.eq(j).remove();
				  }
				};
			};
		}
};

$(document).ready(function(){
	$('form input, form textarea').blur(function(){
		removeRepeated();
	});

	$("#error-message-wrapper").bind("DOMSubtreeModified", function() {
    	removeRepeated();
    	styleErrorMessage();
	});
});


function styleErrorMessage(){
	if ( $("#error-message-wrapper div").text().trim().length ) {
    	$("#error-message-wrapper").addClass("error-msg-box");
	}
	else{
		$("#error-message-wrapper").removeClass("error-msg-box");
	}
};

$.widget( "ui.dialog", $.ui.dialog, {
  _allowInteraction: function( event ) {
    return !!$( event.target ).closest( "#simplemodal-container" ).length || this._super( event );
  }
});