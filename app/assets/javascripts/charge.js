// #
// # Dynamic Select Box
// #
// # http://railscasts.com/episodes/88-dynamic-select-menus-revised?view=asciicast
// #
// # Select boxes using class identifier instead of id (as we need) more than one
// # selected box on the same form.
// # js-dynamic-group - outer box containing the related select boxes.
// # js-dynamic-filter - selecting dropdown filters the results
// # js-dynamic-result - the dropdown whose results are reduced by the filtering.
// #
// #

// ready - executes when HTML-Document is loaded and DOM is ready
$( document ).ready(function() {
  var results;
  results = $('.js-dynamic-result').html();
  console.log(results);

  $('.js-dynamic-filter').change(function(event) {
    event.preventDefault();
    updatePayment($(this));
  });

  // trigger fires the event handler bound to element without a user interaction
  // $('.js-dynamic-filter').trigger('change');

  function updatePayment(toggle) {
    filter = $("option:selected", toggle).html();
    escaped_filter = filter.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1');
    options = $(results).filter("optgroup[label=" + escaped_filter + "]").html();
    console.log(options);
    if (options) {
      return $(toggle).closest('.js-dynamic-group').find('.js-dynamic-result').html(options);
    } else {
      return $(toggle).closest('.js-dynamic-group').find('.js-dynamic-result').empty();
    }
  }

});

// load - executes when complete page is fully loaded, including all frames, objects and images
$(window).load(function() {
  // if I trigger this during ready then capybara webkit tests
  // fail. If I wait for load it works.
  $('.js-dynamic-filter').trigger('change');
});
