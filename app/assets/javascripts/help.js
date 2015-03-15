// note summit is top value because top is not a suitable js name

$( document ).ready(function() {

  $('.js-start-help').click(function() {
    box = 1;
    summit =  parseInt($("#help-me").attr('data-summit'));
    clear();
    $('#help-search')[0].style.display = 'block';



    return false;
  });

//Summit values are normally set to 4 or 6

  $('.js-help').click(function() {

  box++;

//alert('box is '+box+' summit is '+summit)

  if (box == summit )
   {
      clear();
      $('#help-pr')[0].style.display = 'block';
    }

  if (box > summit )
  {
    $('#help-pr')[0].style.display = 'none';
    $('#help-log')[0].style.display = 'block';
  box = 0;
  }

  if (box == 1 )
  {
    $('#help-log')[0].style.display = 'none';
    $('#help-search')[0].style.display = 'block';
  }

  if (box == 2 )
  {
    $('#help-search')[0].style.display = 'none';
    $('#help-2')[0].style.display = 'block';
  }

  if (box == 3 )
  {
    $('#help-2')[0].style.display = 'none';
    $('#help-3')[0].style.display = 'block';
  }

  if (box == 4 )
  {
    $('#help-3')[0].style.display = 'none';
    $('#help-4')[0].style.display = 'block';
  }

  if (box == 5 )
  {
    $('#help-4')[0].style.display = 'none';
    $('#help-5')[0].style.display = 'block';
  }

  if (box == 6 )
  {
    $('#help-5')[0].style.display = 'none';
    $('#help-6')[0].style.display = 'block';
  }

  return false;

  });

  $('.js-cancel-help').click(function() {

  clear();
  return false;

  });
 });

// If an id which does not exist is set to none the js blows.
// The short summits, value 3, have help boxes to 2
function clear() {

  $('#help-search')[0].style.display = 'none';
  $('#help-pr')[0].style.display = 'none';
  $('#help-log')[0].style.display = 'none';
  $('#help-2')[0].style.display = 'none';
  if (summit>3){clearall();}
  return false;
}

// Cannot callup any id in function which is not know to page
// This makes for rather messy cancellation
// Dummy boxes are also clumsy
function clearall() {

  $('#help-3')[0].style.display = 'none';

  if (summit>=5){clear4();}
  if (summit>=6){clear5();}
  if (summit>=7){clear6();}

  return false;
}

function clear4() {

  $('#help-4')[0].style.display = 'none';
  return false;
}

function clear5() {

  $('#help-5')[0].style.display = 'none';
  return false;
}

function clear6() {

  $('#help-6')[0].style.display = 'none';
  return false;
}
