$( document ).ready(function() {

  $('.js-start-help').click(function() {

    $('#help-search')[0].style.display = 'block';
    hcount = 1;
    pay =  parseInt($("#help-me").attr('data-pay'));
    skip =  parseInt($("#help-me").attr('data-skip'));
    itext =  parseInt($("#help-me").attr('data-itext'));

    return false;
  });

  $('.js-help').click(function() {

    if (skip == 3 )
    {
      hcount++;
      if (hcount == 2 ) { hcount= hcount +3; }
    }
    else
    {
      // hcount will become 3 + whatever jump needed
      // pay is 0 when payment help box needed, 1 to jump over case 3
      // skip is 0 when case4 is needed
      if (hcount == 2) { hcount = hcount + pay + skip; }

      //  // When hcount is 2 this gives index view
      hcount++;

      // // itext added for invoice texts to jump over delete
      if (hcount == 5 ) { hcount = hcount + itext; }

      // alert('Finally hcount is '+hcount+'  pay is '+pay+'  skip is '+skip+'  itext is '+itext);

      clearrest();
    }

    clearmain();

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

    clearmain();
    clearrest();
    clearpay();
    return false;

  });
});


function show3() {

  $('#help-3')[0].style.display = 'block';

  return false;
}

function show4() {

  $('#help-4')[0].style.display = 'block';

  return false;
}

function show5() {

  $('#help-5')[0].style.display = 'block';

  return false;
}

// These delete the help boxes before next box set up

function clearmain() {

  $('#help-search')[0].style.display = 'none';
  if (itext==0) {  $('#help-5')[0].style.display = 'none'; }
  $('#help-pr')[0].style.display = 'none';
  $('#help-log')[0].style.display = 'none';

  return false;
}

function clearrest() {

  $('#help-2')[0].style.display = 'none';
  $('#help-4')[0].style.display = 'none';
  if (pay == 0) { clearpay(); }
  return false;
}

function clearpay() {
  $('#help-3')[0].style.display = 'none';
  return false;
}
