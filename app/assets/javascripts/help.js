$( document ).ready(function() {

  $('.js-start-help').click(function() {

    $('#help-1')[0].style.display = 'block';
    hcount = 1;
    return false;

  });

  $('.js-help').click(function() {

    skip =  $("#help-me").attr('data-skip');
    if (hcount == 1) {
      if (skip == 1) { hcount =  2; }
      if (skip == 4) { hcount =  skip; }
    }
    hcount++;

    clearaway(skip);

    switch( hcount) {

      case 1:
        $('#help-1')[0].style.display = 'block';
      break;
      case 2:
        show2();
      break;
      case 3:
        show3();
      break;
      case 4:
        show4();
      break;
      case 5:
        $('#help-pr')[0].style.display = 'block';
      break;
      case 6:
        $('#help-log')[0].style.display = 'block';
        hcount = 0;
      break;

      default:
      break;
    }
    return false;

  });

  $('.js-cancel-help').click(function() {

    clearaway(skip);

    return false;
   });

});


function show2() {

  $('#help-2')[0].style.display = 'block';

  return false;
}

function show3() {

  $('#help-edit')[0].style.display = 'block';

  return false;
}
function show4() {

  $('#help-delete')[0].style.display = 'block';

  return false;
}

// These delete the help boxes before next box set up

function clearaway(skip) {

  $('#help-1')[0].style.display = 'none';
  $('#help-pr')[0].style.display = 'none';
  $('#help-log')[0].style.display = 'none';

  if (skip == 0) { clearskip0(); }
  if (skip == 1) { clearskip1(); }

  return false;
}

function clearskip0() {

  $('#help-2')[0].style.display = 'none';
  $('#help-edit')[0].style.display = 'none';
  $('#help-delete')[0].style.display = 'none';

  return false;
}

function clearskip1() {

  $('#help-edit')[0].style.display = 'none';
  $('#help-delete')[0].style.display = 'none';

  return false;
}
