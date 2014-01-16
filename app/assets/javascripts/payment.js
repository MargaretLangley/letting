$(document).ready(function() {
  calculateTotal($(this).find('.js-amount'));
});

$(function () {
   $('.js-amount').keyup(function(){
      calculateTotal(this);
  });

 $('#address').hover(function() {
      $('#js-popup').show();
  }, function() {
      $('#js-popup').hide();
  });
});

function calculateTotal( src ) {
    var sum = 0,
        tbl = $(src).closest('.js-totalizer');
    tbl.find('.js-amount').each(function( index, elem ) {
        var val = parseFloat($(elem).val());
        if( !isNaN( val ) ) {
            sum += val;
        }
    });
    tbl.find('.js-total').val(sum.toFixed(2));
}
