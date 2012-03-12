// As usual
$(document).ready(location_init);

// When the Ajax-event is complete, i.e. when the content is pulled in:
$(document).bind("end.pjax", location_init);

function location_init() {
    $('#util_location_country_iso2').change(function () {
        $("#util_location_country_iso2").parent().css("display", "inline-block");
        $('#ajax_spinner_fb').show();
        if ($(this).val() == '') {
            $('#util_location_state_iso2').empty();
            $('#util_location_state_iso2').append($('<option>No states</option>'));
        } else {
            $.ajax({
                type: "GET",
                url: "/states/" + $(this).val(),
                success: function (data) {
                    if (data.content === 'None') {
                        $('#util_location_state_iso2').empty();
                        $('#util_location_state_iso2').append($('<option>No states</option>'));
                    }
                    //handle the case where no state related to country selected
                    else {
                        $('#util_location_state_iso2').empty();
                        $('#util_location_state_iso2').append($('<option>Select a state</option>'));
                        $.each(data, function (i, v) {
                            $('#util_location_state_iso2').append($('<option value="' + data[i][1] + '">' + data[i][0] + '</option>'));
                        });
                    }
                    $("#util_location_state_iso2").trigger("liszt:updated");
                    $('#ajax_spinner_fb').hide();
                } //,
                //error: alert('Failed to load states')
            });
        }
    });
}