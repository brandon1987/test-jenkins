(function ($){
	$.fn.setButtonActive = function() {
		var button = $(this);
		button.attr("data-text", button.html());
		button.css("width", button.css("width"));
		//button.prop("disabled", true);
		button.addClass("in-use");
		button.html('<i class="fa fa-spin fa-spinner"></i>');
	};

	$.fn.setButtonCompleted = function(succeeded, message) {
		if(succeeded) {
			$(this).setButtonSucceeded(message);
		} else {
			$(this).setButtonFailed(message);
		}
	}

	$.fn.setButtonSucceeded = function(successMessage) {
		successMessage = successMessage || '<i class="fa fa-check"></i>';
		
		var button = $(this);
		button.html(successMessage);
		button.removeClass("in-use").addClass("succeeded");
		
		setTimeout(function(){
			button.removeButtonMods();
		}, 5000);
	}

	$.fn.setButtonFailed = function(successMessage) {
		successMessage = successMessage || '<i class="fa fa-times"></i>';
		
		var button = $(this);
		button.html(successMessage);
		button.removeClass("in-use").addClass("failed");
		
		setTimeout(function(){
			button.removeButtonMods();
		}, 5000);
	}

	$.fn.removeButtonMods = function() {
		var button = $(this);
		button.removeClass("in-use").removeClass("succeeded").removeClass("failed");
		//button.prop("disabled", false);
		button.html(button.attr("data-text"));
	}
})(jQuery);