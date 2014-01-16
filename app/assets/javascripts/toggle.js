$( document ).ready(function() {

  // current panel switch code
  $('.js-toggle').click(function(event) {
    event.preventDefault();
    doToggle($(this));
  });

  $('.js-checkbox-toggle').click(function(event) {
    doToggle($(this));
  });

  function doToggle(toggle) {
    var toggleSelection = toggle.closest('.js-toggle-selection');
    findTogglable(toggleSelection).slideToggle('fast');
    toggle.trigger('toggleEventHandler');
  }

  function findTogglable(element) {
    return element.find('.js-togglable');
  }

  function onWindowLoad() {
    $('.js-toggle-on-start').toggle();
  }

   // enity specific code - separated from the generic js-toggle code
   // by event handler.
  $('.js-entity-event').on('toggleEventHandler', function() {
    var toggleSelection = $(this).closest('.js-toggle-selection');
    toggleSelection.find('.model_type').val($(this).data('model-type-to'));
  });

  $(onWindowLoad);

});

