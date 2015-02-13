$(function(){
	websocket.on('mjob_visit_reload', function(msg){
		console.log("trigger reload");
		maintenanceGrid.api().ajax.reload();
	});
	websocket.on('mjob_reload', function(msg){
		console.log("trigger reload");
		maintenanceGrid.api().ajax.reload();
	});	


});
