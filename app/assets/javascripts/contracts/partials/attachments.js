$(document).ready(function() {
	var uploadexcludelist=new Array();
	var ajaxrequests=new Array();

	$("#attachmentfiles").nicefileinput();
	$("#uploadattachments").click(function(){
		fileInputElement=document.getElementById("attachmentfiles");
		for (var i=0; i<fileInputElement.files.length; i++) {
			if ($.inArray(i.toString(), uploadexcludelist) == -1) {
				$("#fileuploadstatus"+i).html("Status: Uploading...");

				var formData = new FormData();

				formData.append("userfile", fileInputElement.files[i]);
				formData.append("id",       CONTRACT_ID);
				formData.append("uploadno", i);

				ajaxrequests.push($.ajax({
					type:       'POST',
					url:        '/attachments/contracts',
					processData: false,
					contentType: false,
					data:        formData,
					success: function(data) {
						if (data.success==true){
							$("#fileuploadstatus"+data.uploadno).html("Status: Complete");
							$("#fileupload"+data.uploadno).hide("fade");
							$('#fileuploadform').trigger("reset");
						}else{
							$("#fileuploadstatus"+data.uploadno).html("Status: Problem Uploading");
							console.log("error uploading file");
							console.log(data.error);
						}
					}
				}));
			}
		}

		$.when.apply($, ajaxrequests).done(function(){ 
			websocket.emit('contract_file_attach_reload', COMPANY_ID,CONTRACT_ID); 
		});
	});

	$("#deleteattachment").click(function(){
		

		swal({
			title: "Are you sure?",
			text: "You are about to permanently delete the attached file(s) are you sure you wish to proceed?",
			type: "warning",
			showCancelButton: true,
			confirmButtonColor: "#DD6B55",
			confirmButtonText: "Yes. Delete the file(s)",
			closeOnConfirm: true },
			deleteAttachment);
	});

	$("#attachmentfiles").change(function(){
		fileInputElement=document.getElementById("attachmentfiles");
		uploadexcludelist=[];
		var uploadqueue="";
		for(var i=0;i<fileInputElement.files.length;i++){
			uploadqueue+="<div id='fileupload"+i+"' class='fileuploaditem borderpanel' style='margin-top:5px'><table style='width:100%'><tr><td>"
			uploadqueue+=fileInputElement.files[i].name
			uploadqueue+="</td><td id='fileuploadstatus"+i+"' style='width:150px'>Status: Pending Upload</td><td style='width:100px;text-align:right'><span id='fileuploadremove"+i+"'>Remove <i class='fa fa-times-circle'></span></td></tr></table>"
			uploadqueue+="</div>"
		}
		$("#filestoupload").html(uploadqueue);
		for(var i=0;i<fileInputElement.files.length;i++){
			$("#fileuploadremove"+i).click(function(){
				var removeindex=$(this).attr("id").replace("fileuploadremove","")
				uploadexcludelist.push(removeindex) ;
				$("#fileupload"+removeindex).remove();
			});
		}
	});

	$("#downloadattachment").click(function(){
		fetchrows=taskAttachedFilesGrid.getSelectedRowIds().split(",");

		for(var i=0;i<fetchrows.length;i++){
			var fileurl='/attachments/contracts?id='+CONTRACT_ID+'&filename='+taskAttachedFilesGrid.getGridCellValue(parseInt(fetchrows[i]),0);
			console.log (fileurl);
			$.fileDownload(fileurl, {
				successCallback: function (url) {
					alert('You just got a file download dialog or ribbon for this URL :' + url);
				},
				failCallback: function (html, url) {
					alert('Your file download just failed for this URL:' + url + '\r\n' +
						'Here was the resulting error HTML: \r\n' + html
					);
				}
			});
		}
	});

	reloadAttachedFilesList();
});

function reloadAttachedFilesList() {
	tinyAjaxLoad("POST","/partials/attached_file_list",{'id': CONTRACT_ID,'folder':'contracts'}, function(data) {
		try{
			taskAttachedFilesGrid.fnDestroy();
		} catch(e){}					
		$("#currentattachedfileslist").empty();
		$("#currentattachedfileslist").html(data);		
		loadTaskAttachedFilesGrid();
	});	
}

function tinyAjaxLoad(posttype,partialname,args,callback){
    completeargs={'partialname':partialname};
	for (var attrname in args) { completeargs[attrname] = args[attrname]; }			
	$.ajax({
		type: posttype,
		url: '/partial/partialrender',
		data: completeargs,
		cache: false,
		success: function(data) {
			callback(data);		
		}
	});		

}

function loadTaskAttachedFilesGrid(){
	taskAttachedFilesGrid= $('#attachedfilestable').dataTable( {
        "aoColumnDefs": [
 			{ "sClass": "laligncol",  "aTargets": [0,1] },
 			{ "sClass": "raligncol",  "aTargets": [2] }
        ],		
		"bPaginate": false,
		"bLengthChange": false,
		"bFilter": true,
		"bSort": false,
		"bInfo": false,
		"bAutoWidth":true,
		"sScrollY" : 350 
	});
	taskAttachedFilesGrid.columnFilters();
	taskAttachedFilesGrid.adjustGridAndToggleSize();	
	taskAttachedFilesGrid.enableMultiRowSelection();
}

function deleteAttachment() {
	var ajaxrequests = new Array(); 
	deleterows = taskAttachedFilesGrid.getSelectedRowIds().split(",");
	for (var i = 0; i < deleterows.length; i++) {
		ajaxrequests.push($.ajax({
			type: 'DELETE',
			url: '/attachments/contracts',
			data: {
				"id":       CONTRACT_ID,
				"filename": taskAttachedFilesGrid.getGridCellValue(deleterows[i], 0)
			}
		}));
	}

	$.when.apply($, ajaxrequests).done(function(){ 
		websocket.emit('contract_file_attach_reload', COMPANY_ID,CONTRACT_ID); 
	});
}