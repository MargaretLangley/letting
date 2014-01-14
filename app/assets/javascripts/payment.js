$(document).ready(function() {
  calculateTotal($(this).find('input.amount'));
});

$(function () {
   $('input.amount').keyup(function(){
      calculateTotal(this);
  });

 $('#address').hover(function() {
      $('#popup').show();
  }, function() {
      $('#popup').hide();
  });
});

function calculateTotal( src ) {
    var sum = 0,
        tbl = $(src).closest('.totalizer');
    tbl.find('input.amount').each(function( index, elem ) {
        var val = parseFloat($(elem).val());
        if( !isNaN( val ) ) {
            sum += val;
        }
    });
    tbl.find('input.total').val(sum.toFixed(2));
}
