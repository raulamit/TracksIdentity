// As usual
$(document).ready(process_steps_init);

// When the Ajax-event is complete, i.e. when the content is pulled in:
$(document).bind("end.pjax", process_steps_init);

function process_steps_init() {
  $("tr#P_change").hide();
  return $("select#process_step_action_type").change(function() {
    var optionVal;
    optionVal = $(this).val();
    switch (optionVal) {
      case "U":
        return $("tr#P_change").hide();
      case "A":
        return $("tr#P_change").show();
      case "S":
        return $("tr#P_change").show();
    }
  });
}