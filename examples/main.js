$(function() {
  // Setup validator on window so we can play with it
  window.validator = new FieldValidator($('#password')[0], {
    include: {
      minLength: 6,
      uppercase: true,
      lowercase: true,
      numbers: true,
      symbols: true
    },
    exclude: {
      email: $('#email').val(),
      partial_email: $('#email').val().split('@')[0]
    }
  });

  // Listen to changes on email and update the validations
  $(document).on('change', '#email', function() {
    validator.setValidations({
      exclude: {
        email: $(this).val(),
        partial_email: $(this).val().split('@')[0]
      }
    });
  });

  // Activate red/green validations under input on key up
  $(document).on('keyup', '#password', _.debounce(function(e) {
    var errors = validator.validate();

    $('.validations').children('span')
      .removeClass('active-error active-success');

    // Don't do anything if the user hasn't typed anything
    if (!this.value) {
      $('.error-messages').remove();
      return;
    }

    $.each(errors.requirements.include, function(i, error) {
      $('.validations').find('.' + error)
        .addClass('active-error');
    });

    $('.validations span:not(.active-error)').addClass('active-success');
  }, 300));

  // On submit, show full messages for anything still failing
  $(document).on('submit', 'form', function(e) {
    e.preventDefault();
    var errors = validator.validate();

    $('.error-messages').remove();

    // Don't show messages if the user hasn't typed anything
    if (!$('#password').val().length) return;

    // Use the handy list helper to build a DOM fragment
    if (!errors.valid) {
      $('.validations').append(errors.toList('fullMessages'));
    }
  });
});
