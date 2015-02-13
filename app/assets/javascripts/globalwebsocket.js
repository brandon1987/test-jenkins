$(document).ready(function(){

	if (typeof COMPANY_ID!="undefined"){
		doWebsocketConnect();
		websocket.on('phone_reload', function(msg){
			load_notifications_list();
		});		
	


		$(window).on('beforeunload', function(){
			try {
			    websocket.close();
			}
			catch(err) {
			    console.log(err.message);
			}	
		});

	}
});


function doWebsocketConnect(){
	try {
		websocket = io('https://messaging.constructionmanager.net:3001');
		websocket.emit("join_room", COMPANY_ID);
	}
	catch(err) {
	    console.log(err.message);
	}	
}


