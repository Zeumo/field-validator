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
    this.updateMatchers();
    this.updateMessages();
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
    var errors, req;
    errors = {
      requirements: {
        include: this.validateType('include'),
        exclude: this.validateType('exclude')
      },
      messages: [],
      fullMessages: [],
      toList: this.toList
    };
    req = errors.requirements;
    req.include = _.compact(_.flatten(req.include));
    req.exclude = _.compact(_.flatten(req.exclude));
    errors.valid = !req.include.length && !req.exclude.length;
    errors.requirements = req;
    errors.messages = this.createMessages(errors);
    errors.fullMessages = this.createFullMessages(errors);
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
    if (this.validations[type][validation]) {
      if (type === 'include') {
        if (!this._matchers[validation].test(value)) {
          return validation;
        }
      }
      if (type === 'exclude') {
        if (this._matchers[validation].test(value)) {
          return validation;
        }
      }
    }
  };

  PasswordValidation.prototype.createFullMessages = function(errors) {
    return _.flatten(_.map(errors.requirements, (function(_this) {
      return function(set, type) {
        var prefix;
        if (type === 'include') {
          prefix = 'Do use';
        } else {
          prefix = "Don't use";
        }
        return _.map(set, function(validation) {
          var body;
          body = _this.template(_this._messages[validation], _this.validations[type]);
          return [prefix, body].join(' ');
        });
      };
    })(this)));
  };

  PasswordValidation.prototype.createMessages = function(errors) {
    return _.flatten(_.map(errors.requirements, (function(_this) {
      return function(set, key) {
        return _.map(set, function(req) {
          return _this.template(_this._messages[req], _this.validations[key]);
        });
      };
    })(this)));
  };

  PasswordValidation.prototype.updateMessages = function() {
    return _.each(this.validations, (function(_this) {
      return function(set, type) {
        return _.each(set, function(v, k) {
          if (!(_this._messages[k] || /length/i.test(k))) {
            return _this._messages[k] = "" + (k.replace('_', ' ')) + ": " + v;
          }
        });
      };
    })(this));
  };

  PasswordValidation.prototype.updateMatchers = function() {
    _.each(this.validations, (function(_this) {
      return function(set) {
        return _.each(set, function(val, validation) {
          return _this._matchers = _.defaults(_this._matchers, set);
        });
      };
    })(this));
    return _.each(this._matchers, (function(_this) {
      return function(v, k) {
        if (typeof v === 'string') {
          return _this._matchers[k] = new RegExp(v);
        }
      };
    })(this));
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

  return PasswordValidation;

})();
