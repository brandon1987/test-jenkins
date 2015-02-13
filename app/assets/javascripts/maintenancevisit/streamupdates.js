$(function(){
	websocket.on('mjob_visit_reload', function(msg){
		maintenanceVisitGrid.api().ajax.reload();
	});
	websocket.on('phone_reload', function(msg){
		maintenanceVisitGrid.api().ajax.reload();
	});
});
