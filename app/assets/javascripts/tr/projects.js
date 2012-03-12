// As usual
$(document).ready(projects_init);

// When the Ajax-event is complete, i.e. when the content is pulled in:
$(document).bind("end.pjax", projects_init);

function projects_init() {
  var percentage;
  percentage = parseInt($("#percent_div").val());
  $("#progressbar").progressbar({
    value: percentage
  });
  $("div#itemstohide_change").show();
  return $("select#project_genre").change(function() {
    var optionVal;
    optionVal = $(this).val();
    switch (optionVal) {
      case "PG_C":
        return $("div#itemstohide_change").hide();
      case "PG_U":
        return $("div#itemstohide_change").show();
    }
  });
}