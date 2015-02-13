(function(window, document) {
	window.inputDialog  = function() {
		if (arguments[0] === undefined) {
			window.console.error('InputDialog expects at least 1 attribute!');
			return false;
		}

		var dialoglabel = arguments[0].dialoglabel || "";
		var inputlabels = arguments[0].inputlabels || "";
		var defaults    = arguments[0].defaults    || "";
		var donefunction= arguments[1] || null;

		var formhtml="<form id='inputdialogform' class='jncinputdialog' action='' onkeypress='return event.keyCode != 13;'><label>"+dialoglabel+"</label><br><table>";
		$.each(inputlabels, function( index, value ) {
			var row = $("<tr/>");

			var label = $("<label/>")
							.attr("for", "inputdialogfield" + index)
							.text(value)
							.appendTo("<td/>");

			var input = $("<input/>")
							.attr("type", "text")
							.attr("id",  "inputdialogfield" + index)
							.attr("name", value);

			try {
				input.attr("value", defaults[index]);
			} catch(e) { console.log(defaults); }

			label.appendTo(row);
			input.appendTo(row);

			formhtml += row.html();
		});
		formhtml+="</table></form><button id='inputdialogconfirm' >OK</button><button id='inputdialogcancel' >CANCEL</button>";

		var dialogcontainer=document.createElement('div');
		dialogcontainer.style.cssText ="display:none";
		dialogcontainer.id="jncinputdialog";
		dialogcontainer.innerHTML=formhtml;
		document.body.appendChild(dialogcontainer);

		var bconfirm=false;
		$(dialogcontainer).modal({onClose:function(){
								if (!bconfirm){donefunction(false,null)};
								$.modal.close();
								$("#inputdialogcancel").unbind();
								$("#inputdialogconfirm").unbind();
								$('#jncinputdialog').remove();
							}
		});

		$("#inputdialogcancel").click(function(){
			$.modal.close();
		});

		// Close the modal if the grey area around it is clicked.
		$(".simplemodal-overlay").click(function() {
			$.modal.close();
		});

		// Close the modal on ESC
		$("#simplemodal-container").keyup(function(e) {
			if (e.keyCode == 27) {
				$.modal.close();
			}
		});

		// Confirm the modal on ENTER
		$("#simplemodal-container").keyup(function(e) {
			if (e.keyCode == 13) {
				$("#inputdialogconfirm").click();
			}
		});

		$("#inputdialogconfirm").click(function(){
			bconfirm=true;
			donefunction(true,$('#inputdialogform').serializeArray());
			$.modal.close();
			$("#inputdialogcancel").unbind();
			$("#inputdialogconfirm").unbind();
			$('#jncinputdialog').remove();
		});
	}
})(window, document);
