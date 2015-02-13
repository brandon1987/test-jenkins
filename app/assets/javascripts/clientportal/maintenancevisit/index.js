//= require "./streamupdates"
//var maintenanceVisitGrid;

function removeA(arr) {
    var what, a = arguments, L = a.length, ax;
    while (L > 1 && arr.length) {
        what = a[--L];
        while ((ax= arr.indexOf(what)) !== -1) {
            arr.splice(ax, 1);
        }
    }
    return arr;
}

function renumbercolumns(columnlist){
	//console.log ("start "+ columnlist)	
	for (var column in columnlist) {
		//console.log("testing:"+column+" found: "+ fullcolumns[columnlist[column]] + " in part filter: "+columns.indexOf(fullcolumns[columnlist[column]]));
		columnlist[column]=columns.indexOf(fullcolumns[columnlist[column]])
	}
	columnlist=removeA(columnlist,-1);
	//console.log ("final"+ columnlist)
	return columnlist;
}

function renumbercolumn(column){
	//console.log ("start "+ columnlist)	
		//console.log("testing:"+column+" found: "+ fullcolumns[columnlist[column]] + " in part filter: "+columns.indexOf(fullcolumns[columnlist[column]]));
		return columns.indexOf(fullcolumns[column])

	//console.log ("final"+ columnlist)

}


function setUpMaintenanceVisitListGrid() {

	ajaxUrl="/clientportal/portal_maintenance_visit/gridajaxdata";


	
	maintenanceVisitGrid = $('#mjob-visit-table').dataTable( {
        "aoColumnDefs": [
            { "sClass": "datetime widecolumn filterdaterangeepoch",  "aTargets": renumbercolumns([7,8,9,10,11]) },
            { "sClass": "mjobvisitcompleted",  "aTargets":renumbercolumns([5]) },
            { "sClass": "widecolumn mjobcompleted",  "aTargets":renumbercolumns([12]) },
            { "sClass": "widecolumn",  "aTargets":renumbercolumns([2,12]) },
            { "sClass": "regularwidthvisit", "aTargets": renumbercolumns([0,1,3,4,13,14]) }
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
		"bSort": false,
		"bInfo": false,
		"bAutoWidth": true,
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
			data.data[index][renumbercolumn(5)]= "<div class='statuscell' cellstatus='cellstatus"+ data.data[index][renumbercolumn(5)].replace(" ","_") +"'>" +data.data[index][renumbercolumn(5)]+"</div>";
			data.data[index][renumbercolumn(6)]="";	
			data.data[index][renumbercolumn(7)]*=1000;
			data.data[index][renumbercolumn(8)]*=1000;
			data.data[index][renumbercolumn(9)]*=1000;
			data.data[index][renumbercolumn(10)]*=1000;
			data.data[index][renumbercolumn(11)]*=1000;
			if(data.data[index][renumbercolumn(9)]!=0 && data.data[index][renumbercolumn(9)]!=null) {
				if(data.data[index][renumbercolumn(9)]<(new Date).getTime()){
					data.data[index][renumbercolumn(6)]="<div class='warningcell'>Start Overdue</div>";
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
	maintenanceVisitGrid.api().ajax.reload();
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