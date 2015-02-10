$( document ).ready(function() {

  $('.js-help').click(function() {
   alert('Help')

    return false;
  });
});

$(document).ready(function(){
    $(".ex .hide").click(function(){
        $(this).parents(".ex").hide("slow");
    });
});


$(document).ready(function(){
    $("p").click(function(){
        $(this).hide();
    });
});
