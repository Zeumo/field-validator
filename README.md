# password-validation

  A UI lib handling password validation feedback

  Depends on Lodash (or Underscore).

# Usage

    new PasswordValidation(document.getElementById('password'), validations)

# Validations

By default, validations are disabled. Core validations are:

* length
* lowercase
* uppercase
* numbers
* symbols

A validation can be a Boolean or RegExp to override the default matchers.

An array of `includes` and `excludes` can also be used to define more complex rules.

# Example

``` javascript
var validator = new PasswordValidation($('#password')[0], {
  length: 6,
  uppercase: true,
  lowercase: true,
  numbers: true,
  symbols: true
});

$(document).on('keyup', '#password', function() {
  var errors = validator.validate();
});
```

# Tests

Run `spec/SpecRunner.html`

# License

MIT
