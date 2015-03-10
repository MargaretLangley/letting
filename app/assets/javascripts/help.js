$( document ).ready(function() {

  $('.js-start-help').click(function() {

    $('#help-search')[0].style.display = 'block';
    hcount = 1;
    skip =  parseInt($("#help-me").attr('data-skip'));
    // pay =  parseInt($("#help-me").attr('data-pay'));

    return false;

  });

  $('.js-help').click(function() {

    if (hcount == 2) {
       if (skip == 1) { hcount++; }
       if (skip == 2) { hcount++; }
       if (skip == 4) { hcount =  5; }
    }

    hcount++;

    if (hcount == 5 && skip ==2) { hcount =  6; }

    clearaway(skip);

    switch( hcount) {

      case 1:
        $('#help-search')[0].style.display = 'block';
      break;
      case 2:
        $('#help-2')[0].style.display = 'block';
      break;
      case 3:
        show3();
      break;
      case 4:
        show4();
      break;
      case 5:
        show5();
      break;
      case 6:
        $('#help-pr')[0].style.display = 'block';
      break;
      case 7:
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


function show3() {

  $('#help-3')[0].style.display = 'block';

  return false;
}

function show4() {

  $('#help-edit')[0].style.display = 'block';

  return false;
}
function show5() {

  $('#help-delete')[0].style.display = 'block';

  return false;
}

// These delete the help boxes before next box set up

function clearaway(skip) {

  $('#help-search')[0].style.display = 'none';
  $('#help-2')[0].style.display = 'none';
  $('#help-pr')[0].style.display = 'none';
  $('#help-log')[0].style.display = 'none';

  if (skip == 0) { clearskip0(); }
  if (skip == 1) { clearskip1(); }
  if (skip == 2) { clearskip2(); }

  return false;
}

function clearskip0() {

  $('#help-3')[0].style.display = 'none';
  $('#help-edit')[0].style.display = 'none';
  $('#help-delete')[0].style.display = 'none';

  return false;
}

function clearskip1() {

  $('#help-edit')[0].style.display = 'none';
  $('#help-delete')[0].style.display = 'none';

  return false;
}

function clearskip2() {

  $('#help-edit')[0].style.display = 'none';

  return false;
}
