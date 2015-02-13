$(function() {
	$("#notes-list").change(noteSelected);
	$("#add-note-button").click(addNote);
	$("#delete-note-button").click(deleteNote);

	setUpDetailsSelectFields();
});

function noteSelected() {
	var val = $(this).val();
	var text = $(this).find("[value=" + val + "]").text();
	$("#notes-details").val(text);
}

function addNote() {
	$("#add-note-button").setButtonActive();
	var memoText = $("#notes-details").val();

	$.ajax({
		type: "POST",
		url: "/memos",
		data: {
			"memo[related_id]": CONTRACT_ID,
			"memo[memo_type]":  220,
			"memo[details]":    memoText
		},
		success: function(response) {
			if (response.success) {
				$("#add-note-button").setButtonSucceeded();

				$("<option/>")
					.attr("value", response.memo_id)
					.text(memoText)
					.prependTo($("#notes-list"));
			} else {
				$("#add-note-button").setButtonFailed();
			}	
		}
	});
}

function deleteNote() {
	$("#delete-note-button").setButtonActive();
	var selectedMemo = $("#notes-list").val();

	$.ajax({
		type: "DELETE",
		url: "/memos/" + selectedMemo,
		success: function(response) {
			if (response.success) {
				$("#delete-note-button").setButtonSucceeded();
				$("#notes-list").find("[value=" + selectedMemo + "]").remove();
			} else {
				$("#delete-note-button").setButtonFailed();
			}
		}
	});
}

function setUpDetailsSelectFields() {
	$("#customer").select2({
		formatSelection: formatdisplay,
		formatResult: formatselect,
		matcher: function(term, text, option) {
			text = (option.attr("id") + option.val()).toUpperCase();
			return text.indexOf(term.toUpperCase())>=0;
		}
	});

	$("#customer").change(function() {
		var name = $("#customer").select2("data").text;
		$("#customer_name").val(name);
	});
}

function formatselect(item) { return "<div class='dropdowntext'>"+ item.id+"</div><div class='dropdowntext'>"+ item.text +"</div>"; }
function formatdisplay(item) { return "[" + item.id + "] " + item.text; }
