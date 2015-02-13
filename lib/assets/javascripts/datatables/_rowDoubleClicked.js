(function ($) {
	$.fn.onRowDoubleClicked = function( callback ){
		$(this).on("dblclick", "tbody tr", function(){
			if ($(this).hasClass("dataTables_empty")) return;

			var id = $(this).attr("id");
			id = id.split("-").pop().split("_").pop();

			callback.call(self, id);
		});
	};
})(jQuery);