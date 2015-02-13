$(function() {
	websocket.on('contract_file_attach_reload', function(msg) {
		if (msg == CONTRACT_ID) {
			reloadAttachedFilesList();
		}
	});
});
