/*
password-validation 0.1.0
A UI lib handling password validation feedback
MIT
2014-05-09
*/
        var PasswordValidation;

PasswordValidation = (function() {
  function PasswordValidation(el, validations) {
    this.el = el;
    this.validations = _.extend(this.validations, validations);
  }

  PasswordValidation.prototype.validations = {
    length: 0,
    lowercase: false,
    uppercase: false,
    numbers: false,
    symbols: false,
    includes: [],
    excludes: []
  };

  PasswordValidation.prototype.validate = function() {
    var errors, value;
    value = this.el.value;
    errors = [];
    if (this.validations.length) {
      if (!(value.length >= this.validations.length)) {
        errors.push('length');
      }
    }
    if (this.validations.lowercase) {
      if (!/[a-z]/.test(value)) {
        errors.push('lowercase');
      }
    }
    if (this.validations.uppercase) {
      if (!/[A-Z]/.test(value)) {
        errors.push('uppercase');
      }
    }
    if (this.validations.numbers) {
      if (!/[0-9]/.test(value)) {
        errors.push('numbers');
      }
    }
    if (this.validations.symbols) {
      if (!/\W/.test(value)) {
        errors.push('symbols');
      }
    }
    if (errors !== []) {
      return errors;
    }
  };

  return PasswordValidation;

})();
