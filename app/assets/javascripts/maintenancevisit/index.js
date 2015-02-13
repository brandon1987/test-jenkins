//= require "./streamupdates"
//var maintenanceVisitGrid;
function setUpMaintenanceVisitListGrid() {

	ajaxUrl="/maintenance_visit/gridajaxdata";
    GRID_NAME='maintenance_visit_grid'

	maintenanceVisitGrid = $('#mjob-visit-table').dataTable( {
        "aoColumnDefs": [
            { "sClass": "mjobvisitcompleted",  "aTargets": [ 5 ] },
            { "sClass": "currency-column",  "aTargets": [] },
            { "sClass": "filterdaterangeepoch datetime",  "aTargets": [7,8,9,10,11] },
            { "sClass": "widecolumn",  "aTargets": [2] },
            { "sClass": "regularwidthvisit",  "aTargets": [0,1,3,4,13,14] }

    
        ],
    	serverSide: true,
   		sServerMethod:'POST',
		ajax:{
		    "url": ajaxUrl,
		    "type": "POST",
		    "data": {'gridname':GRID_NAME}
		    },	
		"deferLoading": 0,		    
		"bPaginate": true,
		"sPaginationType": "full_numbers",
		"bLengthChange": false,
		"bFilter": true,
		"bSort": true,
		"order": [[ 1, "desc" ]],
		"bInfo": false,
		"bAutoWidth": false,
		"scrollX": true,		
		"sScrollY" : ($(".content-main").height()-130),
		"fnInitComplete": function() {
			$("#mjob-table, .dataTables_scrollHeadInner table").animate({
				opacity: 1
			}, 500);
		}     
	});


	maintenanceVisitGrid.on("xhr.dt",function(e, settings, data){
		//console.log(data['data']);
		$.each(data['data'],function(index,value){
			data.data[index][5]= "<div class='statuscell' cellstatus='cellstatus"+ data.data[index][5].replace(" ","_") +"'>" +data.data[index][5]+"</div>"
			data.data[index][6]="";	
			data.data[index][7]*=1000;
			data.data[index][8]*=1000;
			data.data[index][9]*=1000;
			data.data[index][10]*=1000;
			data.data[index][11]*=1000;
			if(data.data[index][9]!=0 && data.data[index][9]!=null) {
				if(data.data[index][9]<(new Date).getTime()){
					data.data[index][6]="<div class='warningcell'>Start Overdue</div>";
				}
			}
		});

	});

	maintenanceVisitGrid.on("draw.dt",function(){
		$('div.statuscell').each(function(index,item){
			$(item).parent().addClass($(item).attr('cellstatus'));
			$(item).parent().addClass("cellstatus2");
		});

		$('.warningcell').each(function(index,item){
			$(item).parent().addClass("celloverdue");
		});


	});
	maintenanceVisitGrid.onRowDoubleClicked(editMaintenance);
	maintenanceVisitGrid.enableMultiRowSelection();
	maintenanceVisitGrid.enableColumnFormatting();
	maintenanceVisitGrid.enableColumnToggling({'grid_name':GRID_NAME});	
	maintenanceVisitGrid.columnFilters();
	maintenanceVisitGrid.adjustGridAndToggleSize();

}




function editMaintenance(id){
	maintenanceVisitGrid.resizeFilters();
}



function onPageLoad() {
	setUpMaintenanceVisitListGrid();

}




$(document).ready(onPageLoad);

$(document).ready(function(){
	$("#maintenance").addClass("menuActive");
});

$(document).ready(function(){
	autoScroll();	
});