$( document ).ready(function() {

  $('.js-start-help').click(function() {

    $('#help-1')[0].style.display = 'block';
    hcount = 1;
    return false;

  });


  $('.js-help').click(function() {

    skip =  $("#help-me").attr('data-skip');
    if (hcount == 1) {
      if (skip != 0) {
        hcount+=1;
      }
    }
    hcount+=1;

    if (hcount == 4) {
      if (skip == 2) {
        hcount+=2;
      }
    }

    switch( hcount) {

      case 1:
        $('#help-log')[0].style.display = 'none';
        $('#help-1')[0].style.display = 'block';
      break;
      case 2:
        $('#help-1')[0].style.display = 'none';
        $('#help-2')[0].style.display = 'block';
      break;
      case 3:
        $('#help-1')[0].style.display = 'none';
        $('#help-2')[0].style.display = 'none';
        $('#help-edit')[0].style.display = 'block';
      break;
      case 4:
        $('#help-edit')[0].style.display = 'none';
        $('#help-delete')[0].style.display = 'block';
      break;
      case 5:
        $('#help-edit')[0].style.display = 'none';
        $('#help-delete')[0].style.display = 'none';
        $('#help-pr')[0].style.display = 'block';
      break;
      case 6:
        $('#help-pr')[0].style.display = 'none';
        $('#help-log')[0].style.display = 'block';
        hcount = 0;
      break;

      default:
        $('#help-delete')[0].style.display = 'none';
      break;
    }
    return false;

  });

  $('.js-help-short').click(function() {

    $('#help-1')[0].style.display = 'none';
    $('#help-pr')[0].style.display = 'block';
    return false;

  });

  $('.js-cancel-help').click(function() {

    $('#help-1')[0].style.display = 'none';
    $('#help-edit')[0].style.display = 'none';
    $('#help-2')[0].style.display = 'none';
    $('#help-delete')[0].style.display = 'none';
    $('#help-pr')[0].style.display = 'none';
    $('#help-log')[0].style.display = 'none';

    return false;

  });
});
