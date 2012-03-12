// As usual
$(document).ready(endless_scroll_init);

// When the Ajax-event is complete, i.e. when the content is pulled in:
$(document).bind("end.pjax", endless_scroll_init);

function endless_scroll_init() {
  if ($('.pagination').length) {
    $(window).scroll(function () {
      var url;
      url = $('.pagination .next a').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').text("Loading more...");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
}