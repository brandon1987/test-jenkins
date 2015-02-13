

$(document).ready(function(){

	$("#asset_statuses_button").click(function(){
		loadAssetStatusList();	
	});

	$("#asset_status_delete").click(function(){
		swal({
		  title: "Delete status",
		  text: "Are you sure you wish to delete this status?",
		  status: "warning",
		  showCancelButton: true,
		  confirmButtonColor: "#DD6B55",
		  confirmButtonText: "Delete",
		},
		function(){
			$.ajax({
				status: 'get',
				url: '/asset_status/delete',
				data: {"id":asset_status_table.getSelectedRowID()},
				success: function(data) {
					loadAssetStatusList();
				}
			});			  
		});		
	});


	$("#asset_status_add").click(function(){
		inputDialog({
		  dialoglabel: "Please enter a name for the status",
		  inputlabels: ["status Name"],
		 },
		 function done(isConfirmed,formdata){
		  	if(isConfirmed) {
		  	var statusname=formdata[0].value;
				$.ajax({
					status: 'post',
					url: '/asset_status/add',
					data: {"name":statusname},
					success: function(data) {
						loadAssetStatusList();
					}
				});		   
		  	}
		 }
		);
	});



});


function loadAssetStatusList(){
		tinyAjaxLoad("POST","/partials/assets/asset_status_list",{},function(data){
				if (typeof(asset_status_table)!="undefined"){
					asset_status_table.fnDestroy();
				}				
				$("#asset_status_dialog_table").html("");
				$("#asset_status_dialog_table").html(data);
				asset_status_table=$("#asset_status_dialog_table").dataTable( {
			        "aoColumnDefs": [
			 			{ "sClass": "laligncol",  "aTargets": [0] },
			        ],		
					"bPaginate": false,
					"bLengthChange": false,
					"bFilter": true,
					"bSort": false,
					"bInfo": false,
					"bAutoWidth":true,
					"sScrollY" : 395, 
				});	
				asset_status_table.enableSingleRowSelection();

				$("#asset_status_dialog").dialog({

					title:"Equipment Status"
				});	

		});
}