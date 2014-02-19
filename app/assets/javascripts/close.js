function readyFn( jQuery ) {
  setTimeout(function () { $('.js-close').slideToggle('fast'); }, 2000);
}

$( document ).ready( readyFn );
