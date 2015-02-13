function BulkMailer() {
	this.SENT = 2;
	this.SENDING = 1;
	this.SEND_FAILED = -1;

	this.clearStatuses = function() {
		this.statuses = {};
		$("#mail-export-count, #mail-export-status").text("0");
		$("#mail-export-notifications").text("");
	};

	this.sendSelectedMails = function() {
		this.clearStatuses();

		var ids = quotesGrid.getSelectedRowIds().split(",");

		$("#mail-export-count").text(ids.length) ;

		for(var i = 0; i < ids.length; i++) {
			var id = ids[i];
			this.statuses[id] = this.SENDING;
		}

		for(var i = 0; i < ids.length; i++) {
			var id = ids[i];
			this.sendMail( id );
		}
	};

	this.sendMail = function(id) {
		var mailer = this;
		$.ajax({
			type: "POST",
			url: "/mail/automailquote/" + id,
			data: {},
			success: function(response) {	
				mailer.onSuccessResponse( id, response.status );
			},
			error: function(response) {
				mailer.statuses[id] = mailer.SEND_FAILED;
			},
			dataType: "json"
		});
	};

	this.onSuccessResponse = function(id, code) {
		switch (code) {
			case 0:
				console.log("Got response with 0");
				this.statuses[id] = this.SENT;
				break;
			case 1:
				console.log("Got response with 1");
				this.statuses[id] = this.SEND_FAILED;
				$("#mail-export-notifications").append("Failed to send quote " +
					id + "<br>");
				break;
		}

		$("#mail-export-status").text(this.getMailsSent() + "/" + 
			this.getTotalMailsToSend());

		if (this.getMailsSent() == this.getTotalMailsToSend()) {
			$("#mail-export-status-close").setButtonSucceeded();
		}
	};

	this.getMailsSent = function() {
		count = 0;
		for (var status in this.statuses) {
			if (this.statuses[status] == this.SENT) {
				count++;
			}
		}

		return count;
	};

	this.getTotalMailsToSend = function() {
		count = 0;
		for (var status in this.statuses) {
			if (this.statuses[status] == this.SENDING ||
				this.statuses[status] == this.SENT) {
				count++;
			}
		}

		return count;
	};
}

function sendBulkEmails() {
	$('#mail-export-status-dialog').dialog('open');
	$("#mail-export-status-close").setButtonActive();
	bulkMailer.sendSelectedMails();
}

function setUpPage() {
	$('#bulk-email-button').click(sendBulkEmails);

	$('#mail-export-status-dialog').dialog({
		width: '200px',
		modal: 'true',
		autoOpen: false
	});

	$("#mail-export-status-close").click(function(){
		$('#mail-export-status-dialog').dialog("close");
	});
}


$(document).ready(setUpPage);