$( document ).ready(function() {

  $('.js-reveal-link').click(function(event) {
    event.preventDefault();
    var parent = findParentofRevealableElements($(this));
    firstHiddenChild(parent).slideToggle('fast');
    if( noHiddenChildren(parent) ) { toggleDisableable($(this)); }
  });

  $('.js-hide-link').click(function(event) {
    event.preventDefault();
    $(this).closest('.js-fieldset').slideToggle('fast');
    $(this).closest('.js-fieldset').find('.js-clearable').val('');
    var selection = findParentofRevealableElements($(this));
    if(anyVisibleChildren(selection)) {
      toggleDisableable($(selection).children('.js-reveal-link'));
     }
  });


  // CHARGE REMOVE FIELDS

  $('.js-destroy-link').click(function(event) {
    event.preventDefault();
    $(this).closest('.js-fieldset').slideToggle('fast');
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('.js-fieldset').find('.js-clearable').prop('disabled', true)
  });


  function findParentofRevealableElements(element) {
    return element.closest('.js-reveal-parent');
  }

  function noHiddenChildren(element) {
    return element.children('.revealable:hidden:first').length === 0;
  }

  function firstHiddenChild(element) {
    return element.children('.revealable:hidden:first');
  }

  function anyVisibleChildren(element) {
    return element.children('.revealable:visible:first').length > 0;
  }

  function toggleDisableable(element) {
    element.toggleClass('disabled');
  }

  function onWindowLoad() {
     var parent = findParentofRevealableElements($('.js-reveal-link'));
     if( noHiddenChildren(parent) ) { toggleDisableable($('.js-reveal-link')); }
  }

  $(onWindowLoad);

});
