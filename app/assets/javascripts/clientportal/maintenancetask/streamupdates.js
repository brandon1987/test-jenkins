$(function(){
	websocket.on('mjob_visit_reload', function(msg){
		maintenanceTaskGrid.api().ajax.reload();
	});
});
