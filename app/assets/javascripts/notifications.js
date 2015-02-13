$(document).ready(function(){

	$("#notification_anchor").on("click",function(){
		if ($("#notification_anchor").hasClass("notificationpin")){
			$("#notification_panel").slideToggle();
			$("#notification_anchor").removeClass("notificationpin");
			$("#notification_anchor").parent().removeClass("menuActive");
		}else{
			$("#notification_panel").css("top",$("#notification_anchor").position().top+$("#notification_anchor").height()+2);
			$("#notification_panel").css("left",$("#notification_anchor").position().left-$("#notification_panel").width()+$("#notification_anchor").width()+26);
			$("#notification_panel").slideToggle();
			$("#notification_anchor").addClass("notificationpin");
			$("#notification_anchor").parent().addClass("menuActive");			
		}


	});

	load_notifications_list();
	pulsate_notification();

	if (typeof websocket!="undefined"){
		websocket.on('notification_reload', function(msg){
			load_notifications_list()
		});
	}

	$("#notification_panel").perfectScrollbar();

});

function load_notifications_list(){
	tinyAjaxLoad("POST","/partials/notifications_list",{},function(data){
		$("#notification_panel").html(data);
		check_notifications_remaining();
		setNotificationLineListeners();
	});
}

function setNotificationLineListeners(){
	$(".notification_delete").click(function(){
		var currentnotification=$(this).parent();
		$.ajax({
			type: "GET",
			url: "/user_notifications/delete_notification",
			data: {"id":$(this).attr("data-notification-id")},
			success: function(data) {
				if (data.success==true){
					currentnotification.hide("slide",function(){
						websocket.emit('notification_reload', COMPANY_ID);
					}) ;
				}
			},dataType: 'json'
		});	
	});

	$(".notification_delete_all").click(function(){
		$.ajax({
			type: "GET",
			url: "/user_notifications/delete_notification_all",
			data: {},
			success: function(data) {
				if (data.success==true){
					$(".notification_line").hide("slide",function(){
						$(".notification_text").hide();
						websocket.emit('notification_reload', COMPANY_ID);
					});
				}
			},dataType: 'json'
		});	
	});
}



function check_notifications_remaining(){
	if($(".notification_line").length==0){
		$("#notification_menu").hide();
		if ($("#notification_anchor").hasClass("notificationpin")){
			$("#notification_panel").slideToggle();
			$("#notification_anchor").removeClass("notificationpin");
			$("#notification_anchor").parent().removeClass("menuActive");
		}		
	}else{
		$("#notification_menu").show()
	}


}



function pulsate_notification() {
	// $("#notification_icon").
	  // animate({"text-shadow":"0 0 2px white"}, 2000, 'linear').
	  // animate({"text-shadow":"0 0 0px white"}, 2000, 'linear', pulsate_notification);
}

function add_notification(notificationtype,notificationtext, notificationurl){
	$.ajax({
		type: 'GET',
		url: '/user_notifications/add_notification',
		data: {"notificationtype": notificationtype,
			   "notificationtext":notificationtext,
			   "notificationurl":notificationurl
		},
		success: function(data) {
			if (data.success==true){
				websocket.emit('notification_reload', COMPANY_ID);
			}			
		},dataType: 'json'

	});	
}

