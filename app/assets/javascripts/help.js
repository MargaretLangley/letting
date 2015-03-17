// note summit is top value because top is not a suitable js name

$( document ).ready(function() {

  $('.js-start-help').click(function() {
    box = 0;
    summit =  parseInt($("#help-me").attr('data-summit'));
    // alert('*box is '+box+' summit is '+summit);
    cover();
    $('#help-0')[0].style.display = 'block';
    return false;
  });

//Summit values are normally set to 4 or 6

  $('.js-help').click(function() {

    box++;

    // alert('box is '+box+' summit is '+summit);

    if (box == summit )
    {
      cover();
      $('#help-pr')[0].style.display = 'block';
    }

    if (box > summit )
    {
      $('#help-pr')[0].style.display = 'none';
      $('#help-log')[0].style.display = 'block';
      box = -1;
    }

    if (box == 0 )
    {
      $('#help-log')[0].style.display = 'none';
      $('#help-0')[0].style.display = 'block';
    }

    if(box >= 1)
    {
      $('#help-' + (box - 1) )[0].style.display = 'none';
      $('#help-' + box)[0].style.display = 'block';
    }
    return false;

  });

  $('.js-cancel-help').click(function() {

    cover();
    coverall();
    return false;
  });
 });

// If an id which does not exist is set to none the js blows.
// The short summits, value 3, have help boxes to 2
function cover() {

  $('#help-pr')[0].style.display = 'none';
  $('#help-log')[0].style.display = 'none';
  return false;
}

// Cannot callup any id in function which is not know to page
// used by cancel button. Note js does not accept help-box
function coverall() {

  for (help_box = 0;  help_box < summit;  help_box++)
  {
    $('#help-' + help_box)[0].style.display = 'none';
  }
  return false;
}
