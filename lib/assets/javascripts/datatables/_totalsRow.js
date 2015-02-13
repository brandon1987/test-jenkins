(function ($)
{

	$.fn.addTotalsRow=function(){
			var grid=this;
			var gridXScroll=0;

			var totalsrow= grid.getGridWrapper().find('.gridtotalstable')
			if (totalsrow.length==0){
				var columnsCount = grid.find('thead').first().find('tr').first().find('th').length;
			
				var totalsString = '<div class="gridtotalstable" totalscells="">'

				for ( var i = 0; i < columnsCount; i++ )
				{
					totalsString += '<div class="gridtotalscell" style="display:none" ></div>';
				} 

				if($(grid).getGridWrapper().children('.dataTables_scroll').length!=0){
					$(grid).getGridWrapper().children('.dataTables_scroll').after(totalsString) ;
					$(grid).getGridWrapper().children('.dataTables_scroll').children('.dataTables_scrollBody').scroll(function(evt){
					    var currentLeft = $(this).scrollLeft();
					    if(gridXScroll != currentLeft) {
					    	gridXScroll = currentLeft;
							$(grid).resizeTotals();  //absolutely necessary, redraws totals on horizontal scroll
						}
					});

				}else{
					$(grid).getGridWrapper().children('.dataTable').after(totalsString) ;
				}
				$(grid).on("preXhr.dt",function(){
					var footerstable = grid.getGridWrapper().find('.gridtotalstable')
					var footers = footerstable.find('.filledtotalcell');				
					footers.css("display","none");						
					$(grid).fadeOut(100,function(){
						$(grid).css('visibility','hidden');
						$(grid).show();
					});
				});

				$(grid).on( 'error.dt', function ( e, settings, techNote, message ) {
				        console.log( 'An error has been reported by DataTables: ', message );
						$(grid).resizeFilters();
						$(grid).resizeTotals();				
						$(grid).hide();
						$(grid).css('visibility','visible');
						$(grid).fadeIn();					        
		    	});

				$(grid).on("draw.dt",function(){
					setTimeout(function(){  
						$(grid).resizeFilters();
						$(grid).resizeTotals();				
						$(grid).hide();
						$(grid).css('visibility','visible');
						$(grid).fadeIn();						
					}, 100);							
				});				
			}

	}

	$.fn.getTotals=function(){
		 var grid=this;
		 return(grid.getGridWrapper().find('.gridtotalstable'));
	}

	$.fn.totalsRow = function (action)
	{
		var processCell = function(cell)
		{
			var cellValue = $(cell).text();
			cellValue = cellValue.replace( /[^0-9.]/g, '' );
			cellValue = parseFloat( cellValue );

			return isNaN(cellValue) ? 0 : cellValue;
		}

		var calculateTotals = function()
		{
			var columnsToSum = grid.m_colsToSum.split(',');
			var totals = new Array();

			grid.find('tbody').find('tr').each(function()
			{
				$(this).children('td').each(function()
				{

					var columnIndex = $(this).index();

					if( $.inArray( '' + columnIndex, columnsToSum ) == -1 )
					{
						totals[columnIndex] = "";
						return;
					}

					if( totals[columnIndex] === "" || totals[columnIndex] === undefined )
					{
						totals[columnIndex] = 0;
					}

					totals[columnIndex] += processCell( this );
				})
			})
			return totals;
		}



		var showTotals = function( totals )
		{	
			//$(grid.getGridWrapper()).children(".gridtotalstable").width($(grid).getGridWrapper().width());
			var columnsToSum = grid.m_colsToSum.split(',');
			var headers = grid.find('thead').find("tr[role^='row']").find('th'); //the collection of column headers (used to determine the formatting on this col)

			var footers = grid.getGridWrapper().find('.gridtotalstable').find('div');
			var bodyrow = grid.find('tbody').children(":first-child").children();

			$(footers).removeClass("filledtotalcell");
			

			for( var i = 0; i < totals.length; i++ )
			{
				if( $.inArray( '' + i, columnsToSum ) != -1 ){				
					if( totals[i] !== '' )
					{
						totals[i] = parseFloat( totals[i] ).toFixed( 2 );
						$(footers).eq(i).addClass("filledtotalcell");
					}

					//$(footers).eq(i).css("width",$(bodyrow).eq(i).css( "width" ));
					//$(footers).eq(i).css("max-width",$(bodyrow).eq(i).css( "width" ));
					if($(headers).eq(i).hasClass("currency-column")){ //check to see if column is currency formatted, if so reformat the value before display.
						footers[i].innerHTML = accounting.formatMoney(totals[i], "£", 2, ",", ".");
					}else if ($(headers).eq(i).hasClass("number-column")){
						footers[i].innerHTML = accounting.formatMoney(totals[i], "", 2, ",", ".");
					}else{	
						footers[i].innerHTML = totals[i];	
					}
				}
			}
		}



		var grid = this;

		if( action === 'update' ){

			if(grid.fnSettings().ajax==null){
				showTotals(calculateTotals());
				grid.resizeTotals();
			}else{

			}
		}
		else if(typeof(action)=="undefined"){}
		else if( action.match(/^[0-9]+(,[0-9]+)*$/) )
		{
			grid.m_colsToSum = action;

			// Build filters list
			grid.addTotalsRow();

			$(grid).on("preXhr.dt",function( e, settings, data){
				data['totalcolumns']= grid.m_colsToSum
				grid.getGridWrapper().find('.gridtotalstable').attr("totalscells",action)
			});

			$(grid).on("xhr.dt",function( e, settings, data){
						showTotals(data.totals);		
			});	


			$(grid).on("draw.dt",function(){
				setTimeout(function(){  //this is a FILTHY hack. the column alignment code relies on the grid having rendered in the browser before setting the column sizes in the total row
					//grid.resizeTotals();//so add a 100 ms delay to that so that the browser has a chance to render. (only really affects the alignment on the initial load but looks stupid if it's not done right.)

				}, 10);
			});	

			$(grid).on("page.dt",function(){


			});


		}

		
	};

	$.fn.resizeTotals = function()
		{	

			var grid=this;
					var gridwidth=grid.getGridWrapper().width();
				    $(grid.getGridWrapper()).children(".gridtotalstable").width(gridwidth);
					var bodyheaders=grid.find('thead').children(":first-child").children();
					var footerstable = grid.getGridWrapper().find('.gridtotalstable')
					var footers = footerstable.find('div');
					var colstoshow=grid.getGridWrapper().find('.gridtotalstable').attr("totalscells").split(','); 
					var rightEdgeOffset=8;
					for (i=0;i<footers.length;i++){


						if( $.inArray( '' + i, colstoshow) != -1 || colstoshow[0]==""){	//single entry with "" in it happens when not using the hidden column options
										;
							if(bodyheaders.eq(i).css("display")=="none"){
								footers.eq(i).css("display","none");					
							}else{

								if (footers.eq(i).css("width")!=bodyheaders.eq(i).width()+rightEdgeOffset){
									footers.eq(i).css("width",bodyheaders.eq(i).width()+rightEdgeOffset);
								}
								if (footers.eq(i).css("top")!=footerstable.position().top){
									footers.eq(i).css("top",footerstable.position().top);
								}
								if (footers.eq(i).css("left")!=bodyheaders.eq(i).position().left-2){
									footers.eq(i).css("left",bodyheaders.eq(i).position().left-2);
								}
								if ((bodyheaders.eq(i).position().left-2)>=gridwidth){  //check to see if total will display outside of grid boundaries
									footers.eq(i).css("display","none"); //out of bounds (left too big)
								}else{
									if(bodyheaders.eq(i).position().left-2+bodyheaders.eq(i).width()+rightEdgeOffset>=gridwidth){	//partial out of bounds, adjust width
										footers.eq(i).css("width",gridwidth-(bodyheaders.eq(i).position().left-2));								
										footers.eq(i).css("display","block");
									}else{
										footers.eq(i).css("display","block"); //cell fully in bounds
									}

								}
									
							}
						}else{
							//column wasn't in total array to begin with, don't process
						}

					}			


				
		}

	$.fn.resizeFilters = function()
		{	
			var grid=this;
					var bodyheaders=grid.find('thead').children(":first-child").children();
					var footerstable = grid.getGridWrapper().find('.gridtotalstable')
					var filters = grid.getGridWrapper().find(".dataTables_scrollHeadInner").find("tr").first().find("th")
					for (i=0;i<filters.length;i++){
						if (filters.eq(i).css("display")!="none"){
						
							bodyheaders.eq(i).css("width",filters.eq(i).width());
							bodyheaders.eq(i).css("max-width",filters.eq(i).width());
							bodyheaders.eq(i).css("min-width",filters.eq(i).width());							
						}else{

						}

					}			
					grid.find("td[notip!='true']").each(function(){
								//$(this).attr("title",$(this).text());	 //doing this with dom is slow use jquery instead					
								$(this).tooltip({
							        items: 'td',
							        content: $(this).text(),
							        show:{ delay: 0 }
							    });

					});

				
		}


		$.fn.hasOverflow = function() {
		    var $this = $(this);
		    var $children = $this.find('*');
		    var len = $children.length;

		    if (len) {
		        var maxWidth = 0;
		        var maxHeight = 0
		        $children.map(function(){
		            maxWidth = Math.max(maxWidth, $(this).outerWidth(true));
		            maxHeight = Math.max(maxHeight, $(this).outerHeight(true));
		        });

		        return maxWidth > $this.width() || maxHeight > $this.height();
		    }

		    return false;
		};

		$.fn.gridTooltips = function() {
			$(this).find("td").each(function(item , index){
				$(this).tooltip({
			        items: 'td',
			        content: $(this).text(),
			        show:{ delay: 800 }
			    });				
			});


		}


})(jQuery);