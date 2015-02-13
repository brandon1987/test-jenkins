$(function(){
	websocket.on('redraw_planner', function(msg){
		$('#planneranchor').jsplanner("jsplannerredraw");
	});
});
