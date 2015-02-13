(function ($) {
	$.fn.getHead = function() {
		var grid = this;

		if (grid.fnSettings().oScroll.sY === "") {
			return grid.find('thead');
		} else {
			var selector = "[id=" + grid.attr("id") + "_wrapper] .dataTables_scrollHeadInner";
			return grid.parents(".dataTables_wrapper").find(".dataTables_scrollHeadInner").find("thead");
		}
	}


	$.fn.getGridWrapper = function() {
		var grid = this;
		return grid.parents(".dataTables_wrapper")
	}


	$.fn.setColumnVisibilityByName = function(name, visibility) {
		var grid = this;
		var gridHead = this.getHead();

		var col = gridHead.find("th").filter(function() {
			return $(this).text() === name;
		});
		var colIndex = col.index();

		col.css("display", visibility ? "table-cell" : "none");

		var filter = gridHead.find(".filters").find("th").eq(colIndex);
		filter.css("display", visibility ? "table-cell" : "none");

		grid.find("tr").find("td:eq(" + colIndex + ")").css("display", visibility ? "table-cell" : "none");


	}

	$.fn.adjustGridAndToggleSize = function() {
		var grid = this;
		grid.fnAdjustColumnSizing();
	}

	$.fn.enableColumnFormatting = function(){
		grid=this;
		$(grid).on("xhr.dt",function( e, settings, json ){   //
			var headers = grid.find('thead').find("tr[role^='row']").find('th');
			headers.each(function(index,header){
					if ($(header).hasClass("currency-column")||$(header).hasClass("number-column")||$(header).hasClass("date-short")||$(header).hasClass("date-long")||$(header).hasClass("datetime")){
						for(i=0;i<json.data.length;i++){
							if (json.data[i][index]!="" && json.data[i][index]!=null){  //NOTE: This library only processes epoch timestamps with the milleseconds figures included
								if($(header).hasClass("currency-column")){json.data[i][index]=accounting.formatMoney(json.data[i][index], "£", 2, ",", ".");}
								if($(header).hasClass("number-column")){json.data[i][index]=accounting.formatMoney(json.data[i][index], "", 2, ",", ".");}
								if($(header).hasClass("date-short") || $(header).hasClass("date-long") || $(header).hasClass("datetime")){
									if(json.data[i][index]=='1899-12-30T00:00:00.000Z'){
										json.data[i][index]="";
									}else{
										if($(header).hasClass("date-short")){json.data[i][index]=$.format.date(json.data[i][index], "dd/MM/yy");}
										if($(header).hasClass("date-long")){json.data[i][index]=$.format.date(json.data[i][index], "dd/MM/yyyy");}
										if($(header).hasClass("datetime")){json.data[i][index]=$.format.date(json.data[i][index], "dd/MM/yy HH:mm:ss");}
									}
								}
							}else{
								json.data[i][index]="";
							}
						}
					}
			});
		});
	}

	$.fn.enableColumnToggling = function (options) {
		var attachSettingsBox = function(sidebar) {
			var settings = $('<div class="column-toggles-settings"/>');
			settings.append('<h4 style="margin: 0 0 0 5px;">Rows Per Page</h4>');
			settings.append('<select id="'+options.grid_name+'rowsperpage" style="margin-left:-3px;width:200px"><option value=20>20</option><option value=40>40</option><option value=60>60</option><option value=100>100</option><option value="200">200</option><option value=-1>All</option></select>');

			sidebar.append(settings);
		};
		function reloadGridFilterPopup(){
			tinyAjaxLoad("POST","/partials/popups/global_saved_grid_filters",{'grid_name':options.grid_name},function(data){
				$("#savedgridfilters").html(data);
				initGridFilterPopup();
			});
		}



		var attachToggleDiv = function () {
			grid.addTotalsRow();
			//add button in totals row

			var buttonstate=""
			if(options.hidebutton==true){
				buttonstate="style='display:none'"
			}

			$(grid.getTotals()).after("<div class='grid-options-button-container' id='"+options.grid_name+"-options-button-container'><button id='"+options.grid_name+"-options-button' class='grid-options-button' "+ buttonstate +">Options</button></div>");

			var sidebar = $('<div class="column-toggles" id="'+options.grid_name+'-column-toggles"></div>');

			sidebar.append($('<div class="columns-toggle-sidebar"><div class="arrow-icon"></div></div>'));

			attachSettingsBox(sidebar);


			var form = $('<form class="aligned-form" style="width: 200px;" />');

			form.append('<h4 style="margin: 0 0 0 5px;">Table Filters</h4>');
			form.append('<div id="savedgridfilters" style="margin-left:2px"></div>');
			reloadGridFilterPopup();


			form.append('<table class="gridfilterpresetcontrols"><tr><td><button id="'+options.grid_name+'gridfilterapply" style="width:62px" onclick="return false;">Apply</button></td><td><button id="'+options.grid_name+'gridfiltersave" style="width:62px" onclick="return false;">Save</button></td><td><button id="'+options.grid_name+'gridfilterdelete" style="width:62px" onclick="return false;">Delete</button></td></tr></table>');			

			

			form.append('<h4 style="margin: 0 0 0 5px;">Column Visibility</h4>');
			var columnitems=$("<div class='columntoggleitems' id='"+options.grid_name+"-columntoggleitems' />");
			gridHead.find("[role=row]").find("th").each(function() {
				var columnLabel = $(this).text();

				var row = $('<div class="column-toggle-row"/>');
				row.append(columnLabel);

				columnitems.append(row);
			});
			form.append(columnitems);
			sidebar.append(form);

			var wrapper = grid.parents(".dataTables_wrapper");
			$(grid).getGridWrapper().before(sidebar);


			//Add listeners now that everything is rendered
			$("#"+ options.grid_name+"gridfilterapply").click(function(){
				var presetcolumns=$("#"+options.grid_name+"_popup_saved_grid_filters").select2().find(":selected").attr("data-presetcolumns").split("|");
				var presetvalues=$("#"+options.grid_name+"_popup_saved_grid_filters").select2().find(":selected").attr("data-presetvalues").split("|");
				var combinedpreset=[];
				for(var i=0;i<presetcolumns.length;i++){
					combinedpreset[presetcolumns[i]]=presetvalues[i];
				}
				grid.setColumnFilters(combinedpreset);
			});

			$("#"+options.grid_name+"rowsperpage").select2({
				dropdownAutoWidth:false,
				'width':'200px'
			});

			var rowsperpage=readCookie("grid_page_size");
			if (rowsperpage==null){
				rowsperpage=20;
			}

			$("#"+options.grid_name+"rowsperpage").select2('val',rowsperpage);
			grid.fnSettings()._iDisplayLength =rowsperpage;		

			$("#"+options.grid_name+"rowsperpage").click(function(){
				createCookie("grid_page_size",$("#"+options.grid_name+"rowsperpage").select2().val());
				grid.fnSettings()._iDisplayLength =$("#"+options.grid_name+"rowsperpage").select2().val();
				grid.fnDraw();
			});


			$("#"+ options.grid_name+"gridfiltersave").click(function(){
				var presetname=$("#"+options.grid_name+"_popup_saved_grid_filters").select2("val");
				if(presetname=='!!!invisiblenewpreset!!!'){
					inputDialog({dialoglabel:"Please enter a name for the new filter preset",
								 inputlabels:["Filter Name"],
								},function done(isConfirmed,formdata){
									if(isConfirmed){
										presetname=formdata[0].value;
										processGridFilterSave(presetname)
									}

								}
					);
				}else{
					swal({   title: "Confirm Overwrite",
					   		 text: "Are you sure you wish to overwrite this preset?",   
					   		 type: "warning",   
					   		 showCancelButton: true,   
					   		 confirmButtonColor: "#DD6B55",   
					   		 confirmButtonText: "Yes, Overwrite",   
					   		 closeOnConfirm: true }, 
					   		 function(){   
					   		 	processGridFilterSave(presetname);
			   		 });

					
				}

			});			
			$("#"+ options.grid_name+"gridfilterdelete").click(function(){
				$.ajax({
				type: 'get',
				url: '/saved_grid_filters/deletefilter',
				data: {'presetname':$("#"+options.grid_name+"_popup_saved_grid_filters").select2("val")
					  },
					success: function(data) {
						reloadGridFilterPopup();
					}
				});

			});


			$("#"+options.grid_name+"-options-button").click(function() {
				var optionsButton = $("#" + options.grid_name + "-options-button")
				var toggleHeight  = optionsButton.offset().top - 20;

				$("#"+options.grid_name+"-column-toggles").css({
					height: toggleHeight + "px",
					top:    optionsButton.offset().top-toggleHeight-10,
					left:   optionsButton.offset().left
				});

				$("#"+options.grid_name+"-columntoggleitems").css("height",toggleHeight-180);
				$("#"+options.grid_name+"-column-toggles").fadeToggle(500);
			});

			function processGridFilterSave(presetname){
					$.ajax({
					type: 'get',
					url: '/saved_grid_filters/savefilter',
					data: {'filters':grid.getColumnFilters(),
						   'tablename':options.grid_name,
						   'presetname':presetname},
						success: function(data) {
							reloadGridFilterPopup();
						}
					});
				}
			};


		function getColumnVisibilitySettings() {
			var settings = {};
			$(".column-toggles .column-toggle-row").each(function() {
				settings[$(this).text()] = !$(this).hasClass("disabled");
			});
			return JSON.stringify(settings);
		}

		var saveSettingsToCookie = function() {
			createCookie(cookiePrefix + "columns", encode(getColumnVisibilitySettings()));
		};

		function encode(value) {
			//url encode/decode functions with complete encoding.
			return encodeURIComponent(value).replace(/'/g,"%27").replace(/"/g,"%22");
		}
		function decode(value) {
			return decodeURIComponent(value.replace(/\+/g,  " "));
		}

		var loadSettingsFromCookie = function() {
			var cookie = readCookie(cookiePrefix + "columns");

			if (cookie === null) return ;

			var columns = $.parseJSON(decode(cookie));

			for (column in columns) {
				if (columns.hasOwnProperty(column)) {
					var name = column;
					var state = columns[column];
					if (!state) {
						var filters = $(".column-toggles .column-toggle-row").filter(function() {
							return $(this).text() === name;
						});
						filters.addClass("disabled");
						grid.setColumnVisibilityByName(name, false);
					}
				}
			}
		};

		var grid = this;
		var gridHead = grid.getHead();

		var cookiePrefix = grid.attr("id") + "-";

		attachToggleDiv();

		$(".column-toggles .column-toggle-row").unbind("click");
		$(".column-toggles .column-toggle-row").click(function(){
			var input = $(this);
			var rowIsVisible = !input.hasClass("disabled");
			var label = input.text();

			var col = gridHead.find("th").filter(function() {
				return $(this).text() === label;
			});

			var colIndex = col.index();

			if (rowIsVisible) {
				input.addClass("disabled");
			} else {
				input.removeClass("disabled");
			}

			col.css("display", !rowIsVisible ? "table-cell" : "none");

			var filter = gridHead.find(".filters").find("th").eq(colIndex);
			filter.css("display", !rowIsVisible ? "table-cell" : "none");

			grid.find("tr").find("td:eq(" + colIndex + ")").css("display", !rowIsVisible ? "table-cell" : "none");

			saveSettingsToCookie();

			grid.adjustGridAndToggleSize();
		});

		$(".column-toggles .column-toggles-horizontal-resize").unbind("click");
		$(".column-toggles .column-toggles-horizontal-resize").click(function(){
			var horizScrollEnabled = !$(this).hasClass("disabled");

			if (horizScrollEnabled) {
				$(this).addClass("disabled");
			} else {
				$(this).removeClass("disabled");
			}

			saveSettingsToCookie();
		});

		$(window).resize(function() {
			grid.adjustGridAndToggleSize();
		});

		$(grid).on("draw.dt",function(){ //had to add this to deal with the fact that the ajax reload broke the filtering. now we refilter when the grid fires its draw event.
			grid.totalsRow('update');
			$(".ui-tooltip").hide();
			loadSettingsFromCookie();
			setTimeout(function(){ 
				var bodyheaders=grid.find('thead').children(":first-child").children();
				var headers=grid.getHead().children(":first-child").children();
				for (i=0;i<headers.length;i++){
					headers.eq(i).css("width",bodyheaders.eq(i).css("width"));
				}
			}, 10);




		});



		loadSettingsFromCookie();

	};
})(jQuery);
