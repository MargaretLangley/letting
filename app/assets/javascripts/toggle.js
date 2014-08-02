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
    toggleSelection.children('.js-togglable').slideToggle('fast');
    toggle.trigger('toggleEventHandler');
  }

  // checkbox state affects visibility of selected
  // js classes (js-check-hidden, js-check-visible)
  // event run on page creation and if checkbox toggled.
  //
  if ($('.js-checkbox-toggle').is(':checked')) {
    $('.js-check-hidden').css('display', 'none');
    $('.js-check-visible').css('display', 'block');
  }

  // When toggle event fired it clears field
  // Works on the address district and Nation
  // delete and add cycling.
  //
  $('.js-clear').on('toggleEventHandler', function() {
    $(this).find(':input').val('');
  });
});
