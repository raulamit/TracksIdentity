// As usual
$(document).ready(search_box_init);

// When the Ajax-event is complete, i.e. when the content is pulled in:
$(document).bind("end.pjax", search_box_init);


function search_box_init() {
  $("#search_box").autocomplete({
    source: function(request, response) {
      var curr_user = $('#current_user').val();
      var jqXhr = $.ajax({
        url: "/users/" + curr_user + "/donors",
        type: "get",
        dataType: "json",
        data: {
          search_string: request.term
        },
        success: function(data) {
          response($.map(data, function(item) {
            return {
                url: item.url,
                value: item.name
            }
          }))
        }
      });

      //jqXhr.abort();
    },
    select: function( event, ui ) {
      window.location.href = ui.item.url;
    },
    minLength: 3
  });
}