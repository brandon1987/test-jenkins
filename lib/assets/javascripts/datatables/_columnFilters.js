//=require "./_columnFilterSpecialTypes.js"

/* Given a grid object, add filters to the header.
 */


(function ($) {
	$.fn.columnFilters = function () {
		var getFilterBlock = function() {
			var block = $('<tr class="filters"/>');
			gridHead.find("th").each(function(index){

				var newFilter = $("<th style='display:"+$(this).css("display")+"'/>");


				newFilter.append(getFilterHtml(this,tableObj.getColumnFilterSpecialType(index)));
				//newFilter.append('<input class="text_filter">');
				initSpecialFilters(newFilter,tableObj,index,this);



				newFilter.find("input.text_filter").keyup(function(){
					tableObj.api()
						.columns(index)
						.search($(this).val())
						.draw();
					// trigger the grid to recalculate its totals if it has any
					// (will error if it doesn't but we can just catch and carry on)
					try {
						tableObj.totalsRow('update');
					} catch(e) {
						//console.log(e);
						if(typeof(tableObj.m_colsToSum)!="undefined"){
							tableObj.totalsRow(tableObj.m_colsToSum);
							tableObj.totalsRow('update');	
						}
					}
				});

				block.append(newFilter);
			});
			return block;
		}

		var tableObj = this;
		var gridHead = tableObj.getHead();
		gridHead.children(".filters").remove();
		gridHead.append(getFilterBlock);
	};
	$.fn.getColumnFilterSpecialType=function(index){
		var tableObj = this;
		var gridHead = tableObj.getHead();
		var header=gridHead.find('tr[role="row"]').children().eq(index);
		if ($(header).hasClass("filterdaterangedatetime")){return "filterdaterangedatetime"}
		if ($(header).hasClass("filterdaterangeepoch")){return "filterdaterangeepoch"}
		if ($(header).hasClass("multiselect")){return "multiselect"}
		if ($(header).hasClass("mjobvisitcompleted")){return "mjobvisitcompleted"}		
		if ($(header).hasClass("mjobcompleted")){return "mjobcompleted"}		
		if ($(header).hasClass("contractcompleted")){return "contractcompleted"}		
	}

	$.fn.getColumnFilterValue=function(index){

		var tableObj = this;
		var gridHead = tableObj.getHead();
		filters=gridHead.find("tr.filters");
		var filter=filters.children().eq(index).children();

			switch(tableObj.getColumnFilterSpecialType(index)){
				case "filterdaterangedatetime":
					var datestart="";
					var dateend="";
					if ($(filter).eq(0).val()!=""){
						var d = $(filter).eq(0).datepicker("getDate");;
						datestart=d.getTime()/1000;
					}
					if ($(filter).eq(1).val()!=""){
						var d = $(filter).eq(1).datepicker("getDate");;
						dateend=d.getTime()/1000;
					}
					return '{"type":"filterdaterangedatetime","start":"'+ datestart+ '","end":"'+ dateend	+'"}';
					break;

				case "filterdaterangeepoch":
					var datestart="";
					var dateend="";
					if ($(filter).eq(0).val()!=""){
						var d = $(filter).eq(0).datepicker("getDate");;
						datestart=d.getTime()/1000;
					}
					if ($(filter).eq(1).val()!=""){
						var d = $(filter).eq(1).datepicker("getDate");;
						dateend=d.getTime()/1000;
					}
					return '{"type":"filterdaterangeepoch","start":"'+ datestart+ '","end":"'+ dateend	+'"}';
					break;
				case "contractcompleted":

					return '{"type":"contractcompleted","value":"'+ filter.eq(0).select2("val")+'"}';					
					break;

				case "mjobcompleted":

					return '{"type":"mjobstatus","value":"'+ filter.eq(0).select2("val")+'"}';					
					break;
				case "mjobvisitcompleted":

					return '{"type":"mjobvisitstatus","value":"'+ filter.eq(0).select2("val")+'"}';					
					break;					


				default:
					return filter.eq(0).val();
					break;
			}			

		return ""
	}

	$.fn.getColumnFilters = function () {
			var tableObj = this;
			var gridHead = tableObj.getHead();

			var resultsArray={};
			var filters=gridHead.find(".filters th")

			gridHead.find("[role=row] th").each(function(index,head){
				var filtercontent="";
				$(filters).eq(index).children().each(function(index,filterobj){
					if (filtercontent.length!=0){
						filtercontent+="¬"
					}
					filtercontent+=$(filterobj).val();
				});
				resultsArray[$(head).text()]=filtercontent;
			});
			return resultsArray;
	};

	$.fn.setColumnFilters = function (filtersArray) {
			var tableObj = this;
			var gridHead = tableObj.getHead();

			var resultsArray={};
			var filters=gridHead.find(".filters th")
			gridHead.find("[role=row] th").each(function(index,head){
				var filterterms=filtersArray[$(head).text()].split("¬");

				for(var i=0;i<filterterms.length;i++){
					if($(filters).eq(index).children().eq(i).hasClass("select2-container")){
						$(filters).eq(index).children().eq(i).select2("val", filterterms[i])
					}else{
						$(filters).eq(index).children().eq(i).val(filterterms[i]);
					}
				}


				if (typeof(filtersArray[$(head).text()])!="undefined"){
					tableObj.api().columns(index).search(tableObj.getColumnFilterValue(index));
				}else{
					tableObj.api().columns(index).search("");
				}
			});
			
			tableObj.api().draw();
			try {
				tableObj.totalsRow('update');
			} catch(e) {
				if(typeof(tableObj.m_colsToSum)!="undefined"){
					tableObj.totalsRow(tableObj.m_colsToSum);
					tableObj.totalsRow('update');	
				}
			}


	};




})(jQuery);