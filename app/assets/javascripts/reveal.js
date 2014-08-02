$( document ).ready(function() {

  $('.js-reveal-link').click(function(event) {
    event.preventDefault();
    var parent = findParentofRevealableElements($(this));
    firstHiddenChild(parent).slideToggle('fast');
    if( noHiddenChildren(parent) ) { toggleDisableable($(this)); }
  });

  // Hiding a link
  // We apply a visual affect and clear the fields for reuse.

  $('.js-hide-link').click(function(event) {
    event.preventDefault();
    $(this).closest('.js-fieldset').slideToggle('fast');
    $(this).closest('.js-fieldset').find('.js-clearable').val('');
  });

  // Destroying a link - we set the _destroy field to true and
  // add visual affects of our choosing

  $('.js-destroy-link').click(function(event) {
    event.preventDefault();
    // previous hidden should be a _destroy field
    $(this).prev('input[type=hidden]').val('1')
    // visual affects
    $(this).closest('.js-fieldset').slideToggle('fast');
    $(this).closest('.js-fieldset').find('.js-clearable').prop('disabled', true)
  });


  function findParentofRevealableElements(element) {
    return element.closest('.js-reveal-parent');
  }

  function noHiddenChildren(element) {
    return element.children('.js-revealable:hidden:first').length === 0;
  }

  function firstHiddenChild(element) {
    return element.children('.js-revealable:hidden:first');
  }

  function toggleDisableable(element) {
    element.toggleClass('disabled');
  }

});
