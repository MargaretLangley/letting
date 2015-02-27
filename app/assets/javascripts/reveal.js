
$( document ).ready(function() {

  $('.js-reveal-link').click(function(event) {
    event.preventDefault();
    $(this).closest('.js-group-toggle')
           .children('.js-revealable:hidden:first')
           .slideToggle('fast');

    if ($(this).closest('.js-group-toggle')
           .children('.js-revealable:hidden')
           .length < 1) {
      $(this).addClass('js-color-disabled');
      $(this).prop('Enabled', "False");
    }
  });

  // Hiding a link
  // We apply a visual effect and clear the fields for reuse.

  $('.js-hide-link').click(function(event) {
    event.preventDefault();
    $(this).closest('.js-enclosed-toggle').slideToggle('fast');
    $(this).closest('.js-enclosed-toggle').find('.js-clear').val('');
    $(this).closest('.js-group-toggle')
           .find('.js-reveal-link')
           .prop('Enabled', "True");

    $(this).closest('.js-group-toggle')
           .find('.js-reveal-link')
           .removeClass('js-color-disabled');
  });

  // Destroying a link - we set the _destroy field to true and
  // add visual effects of our choosing

  $('.js-destroy-link').click(function(event) {
    event.preventDefault();
    // previous hidden should be a _destroy field
    $(this).prev('input[type=hidden]').val('1')
    // visual effects
    $(this).closest('.js-enclosed-toggle').slideToggle('fast');
    $(this).closest('.js-enclosed-toggle').find('.js-clear').prop('disabled', true)
  });
});
