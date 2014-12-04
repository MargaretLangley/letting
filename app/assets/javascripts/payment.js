// New Payment Page
// JS totals payments and updates the total if user edits payment.
//

$(document).ready(function() {
  calculateTotal($(this).find('.js-amount'));
});

// updates the total when amount edited.
$(function () {
  $('.js-payment').keyup(function(){
    calculateTotal(this);
  });
});

// Adds total to credits column
function calculateTotal( src ) {
  var sum = 0,
  tbl = $(src).closest('.js-totalizer');
  tbl.find('.js-payment').each(function( index, elem ) {
    var val = parseFloat($(elem).val());
    if( !isNaN( val ) ) {
      sum += val;
    }
  });
  tbl.find('.js-payment-total').val(sum.toFixed(2));
}
