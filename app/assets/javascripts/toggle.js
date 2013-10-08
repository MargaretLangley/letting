$( document ).ready(function() {

  // current panel switch code
  $('.toggle').click(function(event) {
    event.preventDefault();
    doToggle($(this));
  });

  $('.checkbox-toggle').click(function(event) {
    doToggle($(this));
  });

  function doToggle(toggle) {
    var toggleSelection = toggle.closest('.toggle-selection');
    findTogglable(toggleSelection).slideToggle('fast');
    toggle.trigger('toggleEventHandler');
  }

  function findTogglable(element) {
    return element.find('.togglable');
  }

  function onWindowLoad() {
    $('.toggleOnStart').toggle();
  }

   // enity specific code - separated from the generic toggle code
   // by event handler.
  $('.entity-event').on('toggleEventHandler', function() {
    var toggleSelection = $(this).closest('.toggle-selection');
    toggleSelection.find('.model_type').val($(this).data('model-type-to'));
  });

  $(onWindowLoad);

});

