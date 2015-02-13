// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// JQUERY STUFF
//= require "../../../vendor/assets/javascripts/jquery-1.10.2.min"
//= require "../../../vendor/assets/javascripts/jqueryui-1.10.4.min"
// DATATABLES STUFF
//= require "../../../vendor/assets/javascripts/datatables/js/jquery.dataTables"
//= require "../../../vendor/assets/javascripts/select2-3.4.5/select2.min"
// OTHER STUFF
//= require_tree "../../../lib/assets/javascripts"
//= require "../../../vendor/assets/javascripts/jstree/jstree.min.js"
//= require jquery_ujs
// CLOCKPICKER
//= require "../../../vendor/assets/javascripts/clockpicker/dist/jquery-clockpicker.min"
// PAPA PARSE
//= require "../../../vendor/assets/javascripts/papaparse3.1.2.min"
// File Download
//= require "../../../vendor/assets/javascripts/jquery.fileDownload"
// Sweet Alert
//= require "../../../vendor/assets/javascripts/sweetalert/sweet-alert.min"
// jquerynumber
//= require "../../../vendor/assets/javascripts/accounting/accounting.min"
//= require "../../../vendor/assets/javascripts/simplemodal/jquery.simplemodal.1.4.4.min"
//= require "../../../vendor/assets/javascripts/jquery-dateFormat.min"
//= require "../../../vendor/assets/javascripts/jquery.maskedinput.min"

//= require "inputdialog.js"
//= require "../../../vendor/assets/javascripts/perfectscrollbar/min/perfect-scrollbar-0.4.5.min.js"
//= require "globalwebsocket.js"
//= require "notifications.js"

function setContentDivHeight(){
	if ($(".content-main").length == 0) return;
	var h=window.innerHeight|| document.documentElement.clientHeight|| document.body.clientHeight;
	$(".content-main").height(h-($(".content-main").offset().top+$("#footer").outerHeight())-20);
}

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}

$(document).ready(function(){
	$(".dropdown-menu > li").hover(function(){
		$(this).children("ul").css("opacity","0");
		$(this).children("ul").css("display","block");
		$(this).children("ul").fadeTo(400, 1);
	});
	
	$(".dropdown-menu > li").mouseleave(function(){
			$(this).children("ul").css("display","none");
	});

	setContentDivHeight();
	setButtonTooltips();
	$(".ui-tooltip-content").hide();
	$(".ui-tooltip").hide();
}); 


$(document).ready(function(){
if ( $( ".sub-menu-bar" ).length ) {
     $( this ).addClass("shadowMenu");
}
else{
	$(".dropdown-menu").addClass("shadowMenu");
}


});

function autoScroll() {	
	if (typeof $('.dataTables_scrollBody').scrollTop($('tbody tr:nth-child(2)').position() == "undefined")) {
		return;
	}

	$('.dataTables_scrollBody').scrollTop($('tbody tr:nth-child(2)').position().top);
	$('.dataTables_scrollBody').animate({
		scrollTop: $("tbody tr:first-child").position().top
	}, 800);
}	

//commenting this as it causes visual glitches in menus, also less script.
//$(document).ready(function(){
//	$(".dropdown-menu>li>a").focus(function(){
//		$(this).parent().css({
//			'background-color': '#79AEEB',
//			'border-top': '1px solid #79AEEB',
//			'outline': 'none'			
//		});
//	});
//	$(".dropdown-menu>li>a").focusout(function(){		
//		if($(this).parent().hasClass("menuActive")){
//			$(this).parent().css({
//			'background-color': '#9AC2F0',
//			'border-top': 'none',
//			'padding-top': '2px'
//			});
//		}
//		else{
//			$(this).parent().css({
//			'background-color': '#579AE6',
//			'border-top': 'none',
//			'padding-top': '2px'
//			});
//		}		
//	});
//});

$(document).ready(function(){
	$(".expanding_menu_text").hide();
	$(".sub-menu-bar li").hover(function(){
		if($(this).hasClass("button-toggled-on")){
			$(".row_selected").css("background-color", "#e2a1a1");
		}	
	});
	$("li").mouseleave(function(){

		if($(this).hasClass("button-toggled-on")){
			$(".row_selected").css("background-color", "#34495e");
		}	
	});

	$(".expanding_menu_icon").hover(function(){
		var text=$(this).find(".expanding_menu_text");
		if($(text).css("display")=="none" && !$("#notification_anchor").hasClass("notificationpin")){
			$(text).animate({width: 'toggle'},100);
		}
	});

	$(".expanding_menu_icon").mouseleave(function(){
		var text=$(this).find(".expanding_menu_text");
		if($(text).css("display")=="inline-block" && !$("#notification_anchor").hasClass("notificationpin")){
			$(text).animate({width: 'toggle'},100);
		}
	});	


});



function preventLosingUnsavedChanges() {
	$('body').on('change keyup keydown', 'input, textarea, select', function (e) {
		if ($(this).parents(".ui-dialog").length) {
			return;
		}
		
	    $(this).addClass('js-changed-input');
	});

	$(window).on('beforeunload', function () {
		if (document.URL.indexOf("/quotes/") == -1) {
			return undefined;
		}

	    if ($('.js-changed-input').length) {
	        return "You may lose unsaved changes.";
	    }
	});
}



$(document).ready(function(){
	$("form input, form textarea, form select").focus(function(){
		$(this).prev("label").css("color", "#34495E");
	});
	$("form input, form textarea, form select").blur(function(){
		$(this).prev("label").css("color", "inherit");
	});
	$("select").on("select2-open", function() { 
		$(this).parent().children(":first-child").css("color","#34495E");
	});
	$("select").on("select2-close", function() { 
		$(this).parent().children(":first-child").css("color","inherit");
	});

	preventLosingUnsavedChanges();

	setCheckboxTheme();


});


function tinyAjaxLoad(posttype,partialname,args,callback){
    completeargs={'partialname':partialname};
	for (var attrname in args) { completeargs[attrname] = args[attrname]; }			
	$.ajax({
		type: posttype,
		url: '/partial/partialrender',
		data: completeargs,
		success: function(data) {
			callback(data);		
		}
	});		

}

function setButtonTooltips(){
		$(".save-button, .regular-button").tooltip({
	    items: 'button',
	    show:{ delay: 400 }
	});
}

function setCheckboxTheme(selector) {
	selector = selector || "";
	$(selector + ' input').iCheck({
		checkboxClass: 'icheckbox_flat-blue',
		radioClass: 'iradio_flat-blue'
	});
}



