

$(document).ready(function(){

	$("#asset_types_button").click(function(){


		loadAssetTypeList();	
	});

	$("#asset_type_delete").click(function(){
		swal({
		  title: "Delete Type",
		  text: "Are you sure you wish to delete this type?",
		  type: "warning",
		  showCancelButton: true,
		  confirmButtonColor: "#DD6B55",
		  confirmButtonText: "Delete",
		},
		function(){
			$.ajax({
				type: 'get',
				url: '/asset_types/delete',
				data: {"id":asset_type_table.getSelectedRowID()},
				success: function(data) {
					loadAssetTypeList();
				}
			});			  
		});		
	});


	$("#asset_type_add").click(function(){
		inputDialog({
		  dialoglabel: "Please enter a name for the type",
		  inputlabels: ["Type Name"],
		 },
		 function done(isConfirmed,formdata){
		  	if(isConfirmed) {
		  	var typename=formdata[0].value;
				$.ajax({
					type: 'post',
					url: '/asset_types/add',
					data: {"name":typename},
					success: function(data) {
						loadAssetTypeList();
					}
				});		   
		  	}
		 }
		);
	});



});


function loadAssetTypeList(){
		tinyAjaxLoad("POST","/partials/assets/asset_type_list",{},function(data){
				if (typeof(asset_type_table)!="undefined"){
					asset_type_table.fnDestroy();
				}				
				$("#asset_type_dialog_table").html("");
				$("#asset_type_dialog_table").html(data);
				asset_type_table=$("#asset_type_dialog_table").dataTable( {
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
				asset_type_table.enableSingleRowSelection();

				$("#asset_type_dialog").dialog({

					title:"Equipment Types"
				});	

		});
}