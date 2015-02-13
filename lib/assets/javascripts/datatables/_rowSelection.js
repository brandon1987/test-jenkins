(function ($)
{
	var lastSelectedRow=0;
	$.fn.enableSingleRowSelection = function()
	{
		var toggle = function( row )
		{
			if ( !$(row).hasClass('row_selected') )
			{
				$(row).siblings('.row_selected').removeClass('row_selected');
				$(row).addClass('row_selected');
				$('.control-bar .button-toggled-on').each(function(){
					$(this).text( $(this).attr('data-normalLabel') );
					$(this).removeClass('button-toggled-on');
				});
			}
		}

		$(this).on( 'click', 'tbody tr', function()
		{
			if( !$(this).find('td').hasClass('dataTables_empty') )
			{
				toggle( this );
			}
		});
	}

	$.fn.enableMultiRowSelection = function() {
		$(this).addClass("noSelectGrid") //prevent selection of text in the grid (for shift-multi-select)
		$(this).attr('tabindex',"-1"); //give the grid a tabindex so that is selectable in the dom so we can differentiate between grids

		var multiSelect = function(row) {
			if (!$(row).hasClass('row_selected')) {
				$(row).addClass('row_selected');
			} else {
				$(row).removeClass('row_selected');
			}
		}

		var singleSelect = function(row) {
			grid.find(".row_selected").removeClass("row_selected");

			if (!$(row).hasClass('row_selected')) {
				$(row).addClass('row_selected');
			} else {
				$(row).removeClass('row_selected');
			}
		}

		var grid = $(this);

		jQuery(document).keydown(function(e) { 
			if (e.ctrlKey) { //select all
				if (e.keyCode == 65 || e.keyCode == 97) { // 'A' or 'a'
					if ( $(document.activeElement).parents('.dataTables_wrapper').attr("id")==grid.parents('.dataTables_wrapper').attr("id")){	
					e.preventDefault(); //test the currently selected dom object to see if it is this grid. if it is select all rows and prevent propagation of the keystroke elsewhere
					grid.children('tbody').children('tr').removeClass('row_selected');
					grid.children('tbody').children('tr').addClass('row_selected');
					}
				}
			}
		});

		$(this).on('click', 'tbody tr', function(ev) {  
			if (!$(this).find('td').hasClass('dataTables_empty')) {
				$('.control-bar .button-toggled-on').each(function() {
					$(this).text( $(this).attr('data-normalLabel') );
					$(this).removeClass('button-toggled-on');
				});
				//process multi select operations
				if (ev.ctrlKey) { //single ctrl-click multi select
					multiSelect(this);
				} else if (ev.shiftKey) { //shift held multi select
					var currentSelectedRowIndex=$(this).parent().children().index(this);
					if(currentSelectedRowIndex<lastSelectedRowIndex){
						for(i=currentSelectedRowIndex;i<=lastSelectedRowIndex;i++){
							$(this).parent().children("tr:eq("+i+")").removeClass('row_selected');
							$(this).parent().children("tr:eq("+i+")").addClass('row_selected');
						}
					}else if(lastSelectedRowIndex<currentSelectedRowIndex){
						for(i=lastSelectedRowIndex;i<=currentSelectedRowIndex;i++){
							$(this).parent().children("tr:eq("+i+")").removeClass('row_selected');
							$(this).parent().children("tr:eq("+i+")").addClass('row_selected');
						}
					}
				} else {
					singleSelect(this);
				}
				lastSelectedRowIndex=$(this).parent().children().index(this); //remember which row we selected last for multi selecting
			}
		});
	}
	/* END SELECTABLE ROWS */

	$.fn.onRowSelected = function( callback ){  //Added row selected event.
		$(this).on("click", "tbody tr", function(){
			var id=-1;  //when we have grid rows with no id set then this will prevent javascript errors.
			if (typeof($(this).attr("id"))!="undefined"){
				id = $(this).attr("id").split("_").pop();
			}
			if ($(this).hasClass("row_selected")) {
				callback.call(self, id, $(this));				
			}
		});
	};


	$.fn.deleteSelectedRows = function() {
		var selectedRows = this.$('.row_selected');
		if (selectedRows.length !== 0) {
			for (var i = 0; i < selectedRows.length; i++) {
				this.fnDeleteRow(selectedRows[i]);
			}
		}
	};

	$.fn.hasSelectedRows = function()
	{
		var selectedRows = this.$('.row_selected');
		return selectedRows.length !== 0;
	};

	/* Returns the ID of the first selected row, or -1 if the row does not have
	 * an ID.
	 */
	$.fn.getSelectedRowID = function() {
		var id = this.$('.row_selected').first().attr('id');
		
		if (id !== undefined) {
			return id.split("-").pop().split("_").pop();
		} else {
			return -1;
		}			
	}

	$.fn.getCompleteSelectedRowID = function() {
		return this.$('.row_selected').first().attr('id');
	}

	$.fn.getSelectedRowPosition = function() {
		return this.$('.row_selected').first().index();
	}	

	$.fn.getSelectedRowCellValue = function(columnindex) { //return the contents of the nth cell of the selected row of a table
		var row = this.$('.row_selected').first();
		return row.children("td:eq("+columnindex+")").text();
	}

	$.fn.getSelectedRowIds = function() {
		var ids = [];

		this.$('.row_selected').each(function()
		{
			var id = $(this).attr('id');

			if( id !== undefined )
			{
				var parts = $(this).attr('id').split("-");
				ids.push( parts.pop().split("_").pop() );
			}
			else
			{
				ids.push( -1 );
			}			
		});
		
		return ids.join();
	}

	$.fn.getGridCellValue= function(rowid,columnindex){
		 var row=$(this).find("[id='"+rowid+"']");
		 return row.children("td:eq("+columnindex+")").text();
	}


	$.fn.getSelectedRowIDs = function() {
		return this.getSelectedRowIds();
	}
	$.fn.setSelectedRow=function(position){
		if (position!=0){
			var row=this.find("tr[role='row']").eq(position);
			this.find("tr.row_selected[role='row']").removeClass("row_selected");
			row.addClass("row_selected");
		    $(row).click();
		}
	}


	$.fn.getSelectedRow = function()
	{
		return $(this).find('tr.row_selected');
	}

	$.fn.toggleSelectionDeleted=function(){
		var row=$(this).find('tr.row_selected');
		$(row).toggleClass("row_deleted");
	}

})(jQuery);

/* Get the rows which are currently selected */
function fnGetSelected( oTableLocal )
{
	return oTableLocal.$('tr.row_selected');
}