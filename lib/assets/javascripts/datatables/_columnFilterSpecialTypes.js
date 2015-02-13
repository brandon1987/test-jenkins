function getFilterHtml(header,specialtype){

	switch(specialtype){
		case "filterdaterangedatetime"://   
			return '<input value="" class="gridfilterdatepicker nontext_filter" style="float:left"><input value="" class="gridfilterdatepicker nontext_filter" style="float:right"> ';
		case "filterdaterangeepoch":
			return '<input value="" class="gridfilterdatepicker nontext_filter" style="float:left"><input value="" class="gridfilterdatepicker nontext_filter" style="float:right">';
			break;
		case "mjobcompleted":
			return "<select class='mjobcompleted gridfilterdropdown' style='width:100%'><option>";
			break;
		case "mjobvisitcompleted":
			return "<select class='mjobvisitcompleted gridfilterdropdown' style='width:100%'><option>";
			break;			
		case "contractcompleted":
			return "<select class='contractcompleted gridfilterdropdown' style='width:100%'><option>";
			break;			

		case "multiselect":
			return '';
		break;		
		default:
			return '<input class="text_filter">';
		break;
	}

}




function initSpecialFilters(header,tableObj,index,origin){
	//executed after the html for the filterbox is created, used for things like 
	if ($(origin).hasClass("contractcompleted")){
		tableObj.api().columns(index).search( '{"type":"contractcompleted","value":" Not IN (2,3,4,5,6)"}');	//set the default filter selection

		tinyAjaxLoad("POST","/partials/special_grid_filters/contract_list_completion_filter",{}, function(data) {
			$(header).children(".contractcompleted").html(data);
			$(header).children(".contractcompleted").select2();
		});
		$(header).children(".contractcompleted").on("change",function(){
			tableObj.api()
				.columns(index)
				.search(tableObj.getColumnFilterValue(index))
				.draw();
		});
	}

	if ($(origin).hasClass("mjobcompleted")){
		tableObj.api().columns(index).search( '{"type":"mjobstatus","value":" Not IN (4,5,100000)"}');	//set the default filter selection

		tinyAjaxLoad("POST","/partials/special_grid_filters/maintenance_task_list_completion_filter",{}, function(data) {
			$(header).children(".mjobcompleted").html(data);
			$(header).children(".mjobcompleted").select2();
		});
		$(header).children(".mjobcompleted").on("change",function(){
			tableObj.api()
				.columns(index)
				.search(tableObj.getColumnFilterValue(index))
				.draw();
		});
	}

	if ($(origin).hasClass("mjobvisitcompleted")){
		tableObj.api().columns(index).search( '{"type":"mjobvisitstatus","value":" Not IN (8,9)"}');	//set the default filter selection

		tinyAjaxLoad("POST","/partials/special_grid_filters/maintenance_visit_list_completion_filter",{}, function(data) {
			$(header).children(".mjobvisitcompleted").html(data);
			$(header).children(".mjobvisitcompleted").select2();
		});
		$(header).children(".mjobvisitcompleted").on("change",function(){
			tableObj.api()
				.columns(index)
				.search(tableObj.getColumnFilterValue(index))
				.draw();
		});
	}	

	if ($(origin).hasClass("filterdaterangedatetime")){
		$(header).children(".gridfilterdatepicker").datepicker({
			"dateFormat":"dd/mm/yy",
			changeMonth: true,
			changeYear: true			
		});
		$(header).children(".gridfilterdatepicker").mask("99/99/99",{placeholder:"DD/MM/YY"});

		$(header).children(".gridfilterdatepicker").change(function(){
			tableObj.api()
				.columns(index)
				.search(tableObj.getColumnFilterValue(index))
				.draw();
		});
	}

	if ($(origin).hasClass("filterdaterangeepoch")){
		$(header).children(".gridfilterdatepicker").datepicker({
			"dateFormat":"dd/mm/yy",
			changeMonth: true,
			changeYear: true				
		});
		$(header).children(".gridfilterdatepicker").mask("99/99/99",{placeholder:"DD/MM/YY"});
		$(header).children(".gridfilterdatepicker").change(function(){
			tableObj.api()
				.columns(index)
				.search(tableObj.getColumnFilterValue(index))
				.draw();		 	
		});
	}	



}