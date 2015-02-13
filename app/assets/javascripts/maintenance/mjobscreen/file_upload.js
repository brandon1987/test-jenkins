attachmentSubFolder=""


$(document).ready(function() {
  var uploadexcludelist=new Array();
  var ajaxrequests=new Array();
  taskAttachedDirectoryTree="";
  $("#attachmentfiles").nicefileinput();
  $("#uploadattachments").click(function(){
    fileInputElement=document.getElementById("attachmentfiles");
    for(var i=0;i<fileInputElement.files.length;i++){
      if ($.inArray(i.toString(),uploadexcludelist)==-1){
        $("#fileuploadstatus"+i).html("Status: Uploading...")
        var formData = new FormData();
        formData.append("userfile", fileInputElement.files[i]);
        formData.append("targetfolder",attachmentSubFolder);
        formData.append("id",CURRENT_MJOB);
        formData.append("uploadno",i)
        ajaxrequests.push($.ajax({
          type: 'post',
          url: '/maintenance/saveattachment',
          processData: false,
          contentType: false,        
          data: formData,
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
      websocket.emit('mjob_file_attach_reload', COMPANY_ID,CURRENT_MJOB); 
    });
  });

$("#deleteattachment").click(function(){
  var ajaxrequests=new Array(); 
  deleterows=taskAttachedFilesGrid.getSelectedRowIds().split(",");

  swal({
    title: "Are you sure?",
    text: "You are about to permanently delete the attached file(s) are you sure you wisth to proceed?",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Yes. Delete the file(s)",
    closeOnConfirm: true },
    function(){
      for(var i=0;i<deleterows.length;i++){
        ajaxrequests.push($.ajax({
          type: 'post',
          url: '/maintenance/deleteattachment',
          data: {"id":CURRENT_MJOB,
          "filename":attachmentSubFolder +"/"+taskAttachedFilesGrid.getGridCellValue(deleterows[i],0)
        }
      }));
      }
      $.when.apply($, ajaxrequests).done(function(){ 
        websocket.emit('mjob_file_attach_reload', COMPANY_ID,CURRENT_MJOB); 
      }); 
    });
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
  downloadAttachment();
});


$("#attachmentfolderadd").click(function(){
  attachmentAddFolder();
});

$("#attachmentfolcerrename").click(function(){
  attachmentRenameFolder();
});   

$("#attachmentfolderdelete").click(function(){
  attachmentDeleteFolder();
});        



attachmentFolderButtonsEnable(false)
});

function attachmentFolderButtonsEnable(isEnabled){
  if (isEnabled){
    $("#attachmentfolderadd").removeAttr('disabled')
    $("#attachmentfolcerrename").removeAttr('disabled')
    $("#attachmentfolderdelete").removeAttr('disabled')

  }else{
    $("#attachmentfolderadd").attr('disabled','disabled')
    $("#attachmentfolcerrename").attr('disabled','disabled')
    $("#attachmentfolderdelete").attr('disabled','disabled')
  }
}

function downloadAttachment(){

  fetchrows=taskAttachedFilesGrid.getSelectedRowIds().split(",");
  console.log(fetchrows);
  for(var i=0;i<fetchrows.length;i++){
    var fileurl='/maintenance/downloadattachment?id='+CURRENT_MJOB+'&filename='+attachmentSubFolder + "/" +taskAttachedFilesGrid.getGridCellValue(parseInt(fetchrows[i]),0);
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
}

function attachmentAddFolder(){

  inputDialog({dialoglabel:"Please give a name for the new folder",
    inputlabels:["Folder Name"],
    defaults:[""]
  },function done(isConfirmed,formdata){
    if(isConfirmed){
      $.ajax({
        type: 'get',
        url: '/maintenance/addattachmentfolder',
        data: {"id":CURRENT_MJOB,
        "folder":attachmentSubFolder+"/"+formdata[0]['value']},
        success: function(data) {
          reloadAttachedFilesDirectoryTree()
        }
      });           

    }
  }
      );//inputdia




}

function attachmentRenameFolder(){
  var folderroot =attachmentSubFolder.substring(0,attachmentSubFolder.lastIndexOf("/")) ;
  inputDialog({dialoglabel:"Please enter a new name for the new folder",
    inputlabels:["Folder Name"],
    defaults:[""]
  },function done(isConfirmed,formdata){
    if(isConfirmed){
      $.ajax({
        type: 'get',
        url: '/maintenance/renameattachmentfolder',
        data: {"id":CURRENT_MJOB,
        "folder":attachmentSubFolder,
        "newfolder":folderroot+"/"+formdata[0]['value']},
        success: function(data) {
          reloadAttachedFilesDirectoryTree()
        }
      });           

    }
  }
      );//inputdia
}

function attachmentDeleteFolder(){
  swal({
    title: "Are you sure?",
    text: "You are about to delete a folder and its contents",
    type: "warning",
    showCancelButton: true,
    confirmButtonColor: "#DD6B55",
    confirmButtonText: "Delete"
  },
  function(isConfirm){
    if (isConfirm) {
      $.ajax({
        type: 'get',
        url: '/maintenance/deleteattachmentfolder',
        data: {"id":CURRENT_MJOB,
        "folder":attachmentSubFolder},
        success: function(data) {
          reloadAttachedFilesDirectoryTree()
        }
      });

    }

  });

}



function loadTaskAttachedFilesGrid(){
  taskAttachedFilesGrid= $('#attachedfilestable').dataTable( {
    "aoColumnDefs": [
    { "sClass": "laligncol attachfilenamecolumn",  "aTargets": [0] },
    { "sClass": "laligncol attachmodifiedcolumn",  "aTargets": [1] },
    { "sClass": "raligncol attachsizecolumn",  "aTargets": [2] }

    ],    
    "bPaginate": false,
    "bLengthChange": false,
    "bFilter": true,
    "bSort": false,
    "bInfo": false,
    "bAutoWidth":false,
    "sScrollY" : 319
  });
  taskAttachedFilesGrid.columnFilters();
  taskAttachedFilesGrid.adjustGridAndToggleSize();  
  taskAttachedFilesGrid.enableMultiRowSelection();

  attachmentFileButtonsEnable(false);
  $("#attachedfilestable").find("tr[role='row']").click(function(){
    attachmentFileButtonsEnable(true);
  })


}

function attachmentFileButtonsEnable(isEnabled){

  if (isEnabled){
    $("#downloadattachment").removeAttr('disabled')
    $("#deleteattachment").removeAttr('disabled')
  }else{
    $("#downloadattachment").attr('disabled','disabled')
    $("#deleteattachment").attr('disabled','disabled')
  }
}



function reloadAttachedFilesList(){
  $("#filelistloading").show();
  tinyAjaxLoad("POST","/partials/attached_file_list",{'id':CURRENT_MJOB+attachmentSubFolder,'folder':'maintenance'},function(data){
    try{
      taskAttachedFilesGrid.fnDestroy();
    }catch(e){}         
    $("#currentattachedfileslist").empty();
    $("#currentattachedfileslist").html(data);    
    loadTaskAttachedFilesGrid();
    $("#filelistloading").hide();
  });

}

function reloadAttachedFilesDirectoryTree(){
  attachmentSubFolder=""
  tinyAjaxLoad("POST","/partials/attached_directory_tree",{'id':CURRENT_MJOB,'folder':'maintenance'},function(data){
    try{
      taskAttachedDirectoryTree.fnDestroy();
    }catch(e){}         
    $("#attachedfilesdirectorytree").empty();
    $("#attachedfilesdirectorytree").removeClass();
    $("#attachedfilesdirectorytree").html(data);    
    loadTaskAttachedDirectoryTree();

  });   
 }

function loadTaskAttachedDirectoryTree(){
  taskAttachedDirectoryTree=$("#attachedfilesdirectorytree").jstree();
  attachmentFolderButtonsEnable();
  taskAttachedDirectoryTree.on('changed.jstree', function (e, data) { 
  if(typeof(data.instance.get_node(data.selected[0]).li_attr["data-path"])=="undefined"){
      attachmentSubFolder="" //only happens on root node
      attachmentFolderButtonsEnable(false)
      $("#attachmentfolderadd").removeAttr('disabled')
    }else{
      attachmentSubFolder=data.instance.get_node(data.selected[0]).li_attr["data-path"];
      attachmentFolderButtonsEnable(true)
    }
    reloadAttachedFilesList();
  });
}
