$(document).ready(point_of_sale_init);

$(document).bind("end.pjax", point_of_sale_init);

function point_of_sale_init() {
  $("div#if_point_of_sale").hide();
  switch ($("input#campaign_genre").val()) {
    case "CT_PS":
      return $("div#if_point_of_sale").show();
  }
}