// As usual
$(document).ready(tr_init);

// When the Ajax-event is complete, i.e. when the content is pulled in:
$(document).bind("end.pjax", tr_init);

function tr_init() {
  $('#closeBox').click(function() {
    return $('.noticeFlash, .errorFlash').slideUp('slow');
  });
}