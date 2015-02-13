(function ($)
{
	$.fn.getRowByIndex = function( index )
	{
		return $(this).find('tbody').find('tr').get(index);
	}

	$.fn.setIDOfIndex = function( index, id )
	{
		var rows = this.find('tbody tr');
		var row = $(rows).get( index );
		$(row).attr( 'id', id );
	}
})(jQuery);

/* Given an element, select all of the contained text.
 */
function selectText(container) {
	if ( typeof container.select === "function" )
	{
		container.select();
	}
	else
	{
		if (typeof window.getSelection != "undefined" && typeof document.createRange != "undefined") {
	        var range = document.createRange();
	        range.selectNodeContents(container);
	        var sel = window.getSelection();
	        sel.removeAllRanges();
	        sel.addRange(range);
	    } else if (typeof document.selection != "undefined" && typeof document.body.createTextRange != "undefined") {
	        var textRange = document.body.createTextRange();
	        textRange.moveToElementText(container);
	        textRange.select();
	    }
	}
}