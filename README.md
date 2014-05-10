# password-validation

  A UI lib handling password validation feedback

  Depends on Lodash (or Underscore).

# Usage

    new PasswordValidation(document.getElementById('password'), validations)

# Validations

By default, validations are falsey--your string will validate with any characters.

Validations must be specified for `include` or `exclude`:

    new PasswordValidation(document.getElementById('password'), {
      include: {
        minLength: 10
      },
      exclude: {
        email: $('#email').val()
      }
    });

In the above example, the password must be at least 10 characters and cannot contain 'bob'.

Core validations are `includes` only:

* minLength
* lowercase
* uppercase
* numbers
* symbols

When matching length with `excludes` use `maxLength`.

A validation can be a Boolean or RegExp to override the default matchers.

# Example

A complete example can be found in `examples/`.

``` javascript
var validator = new PasswordValidation($('#password')[0], {
  includes: {
    minLength: 10,
    uppercase: true,
    lowercase: true,
    numbers: true,
    symbols: true
  },
  excludes: {
    partial_email: 'bob'
  }
});

$(document).on('keyup', '#password', function() {
  var errors = validator.validate();
});
```

# Tests

Run `spec/SpecRunner.html`

# Contributing

* Clone the project
* Run `npm install`
* Do your thing on a feature branch with tests
* Send a pull request

# License

MIT
