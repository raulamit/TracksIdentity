// As usual
$(document).ready(chosen_init);

// When the Ajax-event is complete, i.e. when the content is pulled in:
$(document).bind("end.pjax", chosen_init);

function chosen_init() {
	$("select").chosen();
}