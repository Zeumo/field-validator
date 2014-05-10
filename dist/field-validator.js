/*
field-validator 0.1.0
A lib designed for giving pleasant password validation feedback
MIT
2014-05-10
*/
        var FieldValidator;

FieldValidator = (function() {
  function FieldValidator(el, validations) {
    this.el = el;
    if (validations == null) {
      validations = {};
    }
    this.validations = _.defaults(validations, this._validations);
    this.setMatchers();
    this.setMessages();
  }

  FieldValidator.prototype._validations = {
    include: {
      minLength: 0,
      lowercase: false,
      uppercase: false,
      numbers: false,
      symbols: false
    }
  };

  FieldValidator.prototype._matchers = {
    lowercase: /[a-z]/,
    uppercase: /[A-Z]/,
    numbers: /[0-9]/,
    symbols: /[^a-zA-Z\d\s]/
  };

  FieldValidator.prototype._messages = {
    minLength: 'at least {minLength} characters',
    maxLength: 'shorter than {minLength} characters',
    lowercase: 'a lowercase letter',
    uppercase: 'an uppercase letter',
    numbers: 'a number',
    symbols: 'a symbol'
  };

  FieldValidator.prototype.messagePrefixes = {
    include: "Do use",
    exclude: "Don't use"
  };

  FieldValidator.prototype.validate = function() {
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

  FieldValidator.prototype.validateType = function(type) {
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

  FieldValidator.prototype.validateLength = function(value, type) {
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

  FieldValidator.prototype.validateMatcher = function(value, type, validation) {
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

  FieldValidator.prototype.createFullMessages = function(errors) {
    return _.flatten(_.map(errors.requirements, (function(_this) {
      return function(set, type) {
        var prefix;
        prefix = _this.messagePrefixes[type];
        return _.map(set, function(validation) {
          var body;
          body = _this.template(_this._messages[validation], _this.validations[type]);
          return [prefix, body].join(' ');
        });
      };
    })(this)));
  };

  FieldValidator.prototype.createMessages = function(errors) {
    return _.flatten(_.map(errors.requirements, (function(_this) {
      return function(set, key) {
        return _.map(set, function(req) {
          return _this.template(_this._messages[req], _this.validations[key]);
        });
      };
    })(this)));
  };

  FieldValidator.prototype.setValidations = function(object) {
    _.merge(this.validations, object);
    this.setMatchers();
    return this.setMessages();
  };

  FieldValidator.prototype.setMessages = function() {
    return _.each(this.validations, (function(_this) {
      return function(set, type) {
        return _.each(set, function(v, k) {
          if (!(typeof v !== 'string' || /length/i.test(k))) {
            return _this._messages[k] = "" + (k.replace('_', ' ')) + ": " + v;
          }
        });
      };
    })(this));
  };

  FieldValidator.prototype.setMatchers = function() {
    _.each(this.validations, (function(_this) {
      return function(set) {
        return _.each(set, function(val, validation) {
          if (typeof val === 'string') {
            return _this._matchers[validation] = val;
          }
        });
      };
    })(this));
    return _.each(this._matchers, (function(_this) {
      return function(v, k) {
        if (typeof v === 'string') {
          _this._matchers[k] = new RegExp(v);
        }
        if (!(_this._matchers[k] instanceof RegExp)) {
          return delete _this._matchers[k];
        }
      };
    })(this));
  };

  FieldValidator.prototype.toList = function(messageType) {
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

  FieldValidator.prototype.template = function(s, d) {
    var p;
    for (p in d) {
      s = s.replace(new RegExp("{" + p + "}", 'g'), d[p]);
    }
    return s;
  };

  return FieldValidator;

})();
