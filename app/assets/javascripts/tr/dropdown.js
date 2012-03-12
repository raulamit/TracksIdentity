/*
 * @author Gaurav Rawat
 * Javascript Used for toggling buttons and menus
 */

// As Usual
$(document).ready(toggle_menu_display_init);

// When the Ajax-event is complete, i.e. when the content is pulled in:
$(document).bind("end.pjax", toggle_menu_display_init);

function toggle_menu_display_init() {
	$('#session').hover(
        function() {
            $(this).addClass("active");
        },
        function() {
            $(this).removeClass("active");
        }
    );

    $('#session a, .logo a, .footer a').click(function (){
        $('#global-nav li a').removeClass("active new");
    });

	$('#top-bar-outer a').click(function() {
		$('#global-nav li a').removeClass("active new");
		$(this).addClass("active new");
	});
}