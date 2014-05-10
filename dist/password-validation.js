/*
password-validation 0.1.0
A UI lib handling password validation feedback
MIT
2014-05-10
*/
        var PasswordValidation;

PasswordValidation = (function() {
  function PasswordValidation(el, validations) {
    this.el = el;
    if (validations == null) {
      validations = {};
    }
    this.validations = _.defaults(validations, this._validations);
  }

  PasswordValidation.prototype._validations = {
    include: {
      minLength: 0,
      lowercase: false,
      uppercase: false,
      numbers: false,
      symbols: false
    }
  };

  PasswordValidation.prototype._matchers = {
    lowercase: /[a-z]/,
    uppercase: /[A-Z]/,
    numbers: /[0-9]/,
    symbols: /[^a-zA-Z\d\s]/
  };

  PasswordValidation.prototype._messages = {
    minLength: 'at least {minLength} characters',
    maxLength: 'shorter than {minLength} characters',
    lowercase: 'a lowercase letter',
    uppercase: 'an uppercase letter',
    numbers: 'a number',
    symbols: 'a symbol'
  };

  PasswordValidation.prototype.validate = function() {
    var errors, value;
    value = this.el.value;
    errors = {
      requirements: {
        include: this.validateType('include'),
        exclude: this.validateType('exclude')
      },
      messages: [],
      fullMessages: [],
      toList: this.toList
    };
    errors.requirements.include = _.compact(_.flatten(errors.requirements.include));
    errors.requirements.exclude = _.compact(_.flatten(errors.requirements.exclude));
    if (_.isEmpty(errors.requirements.include)) {
      delete errors.requirements.include;
    }
    if (_.isEmpty(errors.requirements.exclude)) {
      delete errors.requirements.exclude;
    }
    errors.messages = this.createMessages(errors.requirements);
    errors.fullMessages = this.createFullMessages(errors.messages);
    return errors;
  };

  PasswordValidation.prototype.validateType = function(type) {
    var value;
    value = this.el.value;
    return _.map(this.validations[type], (function(_this) {
      return function(re, validation) {
        if (/length/i.test(validation)) {
          return _this.validateLength(value, type);
        } else {
          return _this.validateMatcher(value, type, validation);
        }
      };
    })(this));
  };

  PasswordValidation.prototype.validateLength = function(value, type) {
    var length, validation;
    if (type === 'include') {
      validation = 'minLength';
      if (length = this.validations[type][validation]) {
        if (!(value.length >= length)) {
          return validation;
        }
      }
    }
    if (type === 'exclude') {
      validation = 'maxLength';
      if (length = this.validations[type][validation]) {
        if (value.length >= length) {
          return validation;
        }
      }
    }
  };

  PasswordValidation.prototype.validateMatcher = function(value, type, validation) {
    var v;
    if (v = this.validations[type][validation]) {
      if (type === 'include') {
        if (!this.defaultRegex(v, this._matchers[validation]).test(value)) {
          return validation;
        }
      }
      if (type === 'exclude') {
        if (this.defaultRegex(v, this._matchers[validation]).test(value)) {
          return validation;
        }
      }
    }
  };

  PasswordValidation.prototype.validateExcludes = function(value) {
    var excludes, validations;
    excludes = _.compact(_.map(_.keys(this.validations), function(key) {
      if (/^exclude/.test(key)) {
        return key;
      }
    }));
    validations = _.map(excludes, (function(_this) {
      return function(key) {
        return _this.validations[key];
      };
    })(this));
    return _.map(validations, function(validation) {
      if (_.contains(value, validation)) {
        return validation;
      }
    });
  };

  PasswordValidation.prototype.defaultRegex = function(regex, fallback) {
    if (regex instanceof RegExp) {
      return regex;
    } else {
      return fallback;
    }
  };

  PasswordValidation.prototype.createFullMessages = function(messages) {
    return _.map(messages, function(message) {
      return "Please use " + message;
    });
  };

  PasswordValidation.prototype.createMessages = function(requirements) {
    return _.flatten(_.map(requirements, (function(_this) {
      return function(set, key) {
        return _.map(set, function(req) {
          return _this.template(_this._messages[req], _this.validations[key]);
        });
      };
    })(this)));
  };

  PasswordValidation.prototype.toList = function(messageType) {
    var $list, messages;
    messages = this[messageType];
    $list = document.createElement('ul');
    $list.className = 'error-messages';
    _.each(messages, function(message) {
      var item;
      item = document.createElement('li');
      item.innerHTML = message;
      return $list.appendChild(item);
    });
    return $list;
  };

  PasswordValidation.prototype.template = function(s, d) {
    var p;
    for (p in d) {
      s = s.replace(new RegExp("{" + p + "}", 'g'), d[p]);
    }
    return s;
  };

  PasswordValidation.prototype.set = function(k, v) {
    return this[k] = v;
  };

  return PasswordValidation;

})();
