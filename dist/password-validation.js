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
    this.validations = validations;
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

  PasswordValidation.prototype.matchers = {
    lowercase: /[a-z]/,
    uppercase: /[A-Z]/,
    numbers: /[0-9]/,
    symbols: /[^a-zA-Z\d\s]/
  };

  PasswordValidation.prototype.validate = function() {
    var errors, excludes_errors, includes_errors, value;
    value = this.el.value;
    errors = [];
    if (this.validations.length) {
      if (!(value.length >= this.validations.length)) {
        errors.push('length');
      }
    }
    _.each(this.matchers, (function(_this) {
      return function(regex, validation) {
        if (_this.validations[validation]) {
          if (!_this.defaultRegex(_this.validations[validation], regex).test(value)) {
            return errors.push(validation);
          }
        }
      };
    })(this));
    includes_errors = _.compact(_.map(this.validations.includes, function(requirement) {
      if (!_.contains(value, requirement)) {
        return requirement;
      }
    }));
    if (includes_errors.length) {
      errors.push({
        include: includes_errors
      });
    }
    excludes_errors = _.compact(_.map(this.validations.excludes, function(requirement) {
      if (_.contains(value, requirement)) {
        return requirement;
      }
    }));
    if (excludes_errors.length) {
      errors.push({
        exclude: excludes_errors
      });
    }
    if (errors.length) {
      return errors;
    }
  };

  PasswordValidation.prototype.defaultRegex = function(regex, fallback) {
    if (regex instanceof RegExp) {
      return regex;
    } else {
      return fallback;
    }
  };

  return PasswordValidation;

})();
