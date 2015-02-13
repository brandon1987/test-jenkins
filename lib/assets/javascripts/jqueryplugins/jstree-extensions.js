(function($) {
	$.fn.getSelectedBranchID = function() {
		if (!$(this).hasSelectedBranch()) {
			return -1;
		}

		// Covers cases where the tree doesn't have ANY nodes.
		if (typeof $(this).jstree("get_selected")[0] !== "string") {
			return -1;
		}

		return $(this).jstree("get_selected")[0].split("_").pop();
	};

	$.fn.hasSelectedBranch = function() {
		return $(this).jstree("get_selected").length > 0;
	}
})(jQuery);