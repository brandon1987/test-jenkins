(function ($) {
	$.fn.listSelector = function() {
		var addStyles = function() {
			listDiv.children().css({
				float: "left",
				height: "100%"
			});

			buttonDiv.css({
				padding: 0,
				width:   "50px",
				margin:  "0 5px"
			});

			selects.css("width", "200px");

			buttons.css("width", "50px");
		}

		var bindEvents = function() {
			listDiv.find(".js-move-all-left").click(moveAllLeft);
			listDiv.find(".js-move-one-left").click(moveOneLeft);
			listDiv.find(".js-move-one-right").click(moveOneRight);
			listDiv.find(".js-move-all-right").click(moveAllRight);
		}

		var moveAllLeft = function() {
			rightList.find("option").appendTo(leftList);
		}

		var moveOneLeft = function() {
			rightList.find(":selected").appendTo(leftList);
		}

		var moveOneRight = function() {
			leftList.find(":selected").appendTo(rightList);
		}

		var moveAllRight = function() {
			leftList.find("option").appendTo(rightList);
		}

		var listDiv   = $(this);
		var selects   = $(this).find("select");
		var leftList  = selects.first();
		var rightList = selects.last();
		var buttonDiv = $(this).find("div");

		$("<button/>").addClass("js-move-all-left").text("<<").appendTo(buttonDiv);
		$("<button/>").addClass("js-move-one-left").text("<").appendTo(buttonDiv);
		$("<button/>").addClass("js-move-one-right").text(">").appendTo(buttonDiv);
		$("<button/>").addClass("js-move-all-right").text(">>").appendTo(buttonDiv);

		var buttons   = $(this).find("button");

		selects.attr("size", 10);
		selects.prop("multiple", true);
		addStyles();
		bindEvents();
	}

	$.fn.getListSelection = function() {
		var getAllSelected = function() {
			var items = {};

			leftList.find("option").each(function() {
				var key = $(this).val();
				var val = $(this).text();
				items[key] = val;
			});

			return JSON.stringify(items);
		}

		var listDiv   = $(this);
		var selects   = $(this).find("select");
		var leftList  = selects.first();

		return getAllSelected();
	}
})(jQuery);