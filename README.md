# password-validation

  A UI lib handling password validation feedback

# Usage

    new PasswordValidation(document.getElementById('password'), validations)

# Validations

By default, all validations are disabled. Core validations:

* length
* lowercase
* uppercase
* numbers
* symbols

An array of `includes` and `excludes` can also be used to define more complex rules.

# Usage

    var = validator = new PasswordValidator($('#password')[0], {
      length: 6,
      uppercase: true,
      lowercase: true,
      numbers: true,
      symbols: true
    });

    $(document).on('keyup', '#password', function() {
      var errors = validator.validate()
    });

# Tests

Run `spec/SpecRunner.html`

# License

MIT
