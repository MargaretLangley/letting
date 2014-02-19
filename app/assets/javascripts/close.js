$( document ).ready(function() {

  $('.js-close-click').click(function(event) {
    $(this).slideToggle('fast');
  });
});

function readyFn( jQuery ) {
  setTimeout(function () { $('.js-close-time').slideToggle('fast'); }, 2000);
}

$( document ).ready( readyFn );

