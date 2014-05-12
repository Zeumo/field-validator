/*  field-validator - 0.1.0 (2014-05-12)
 *  A lib designed for giving pleasant password validation feedback
 *  MIT License
 */

var FieldValidator;

FieldValidator = (function() {
  function FieldValidator(el, validations) {
    this.el = el;
    if (validations == null) {
      validations = {};
    }
    if (this.el.jquery) {
      this.el = this.el[0];
    }
    this.setValidations(validations);
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
    maxLength: 'more than {maxLength} characters',
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
    var status;
    status = {
      errors: {
        include: this.validateType('include'),
        exclude: this.validateType('exclude')
      },
      messages: [],
      fullMessages: [],
      toList: this.toList
    };
    status.valid = !status.errors.include.concat(status.errors.exclude).length;
    status.messages = this.createMessages(status);
    status.fullMessages = this.createFullMessages(status);
    return status;
  };

  FieldValidator.prototype.validateType = function(type) {
    var value;
    value = this.el.value;
    return _.compact(_.map(this.validations[type], (function(_this) {
      return function(v, k) {
        if (/length/i.test(k)) {
          return _this.validateLength(value, type, k);
        } else {
          return _this.validateMatcher(value, type, k);
        }
      };
    })(this)));
  };

  FieldValidator.prototype.validateLength = function(value, type, k) {
    var length;
    length = this.validations[type][k];
    if (value.length <= length && k === 'minLength') {
      return k;
    }
    if (value.length >= length && k === 'maxLength') {
      return k;
    }
  };

  FieldValidator.prototype.validateMatcher = function(value, type, k) {
    if (!this._matchers[k].test(value) && type === 'include') {
      return k;
    }
    if (this._matchers[k].test(value) && type === 'exclude') {
      return k;
    }
  };

  FieldValidator.prototype.createFullMessages = function(status) {
    return _.flatten(_.map(status.errors, (function(_this) {
      return function(set, type) {
        var prefix;
        prefix = _this.messagePrefixes[type];
        return _.map(set, function(v) {
          var body;
          body = _this.template(_this._messages[v], _this.validations[type]);
          return [prefix, body].join(' ');
        });
      };
    })(this)));
  };

  FieldValidator.prototype.createMessages = function(status) {
    return _.flatten(_.map(status.errors, (function(_this) {
      return function(set, type) {
        return _.map(set, function(req) {
          return _this.template(_this._messages[req], _this.validations[type]);
        });
      };
    })(this)));
  };

  FieldValidator.prototype.setValidations = function(object) {
    if (!this.validations) {
      this.validations = _.clone(this._validations);
    }
    _.extend(this.validations, object);
    this.setMatchers();
    return this.setMessages();
  };

  FieldValidator.prototype.setMessages = function() {
    return _.each(this.validations, (function(_this) {
      return function(set, type) {
        return _.each(set, function(v, k) {
          if (typeof v === 'string' && !/length/i.test(k)) {
            return _this._messages[k] = "" + (k.replace('_', ' ')) + ": " + v;
          }
        });
      };
    })(this));
  };

  FieldValidator.prototype.setMatchers = function() {
    _.each(this.validations, (function(_this) {
      return function(set) {
        return _.each(set, function(v, k) {
          if (typeof v === 'string') {
            return _this._matchers[k] = v;
          }
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

  FieldValidator.prototype.toList = function(messageType) {
    var $list;
    $list = document.createElement('ul');
    $list.className = 'error-messages';
    _.each(this[messageType], function(message) {
      var item;
      item = document.createElement('li');
      item.innerHTML = message;
      return $list.appendChild(item);
    });
    return $list;
  };

  FieldValidator.prototype.template = function(s, d) {
    var k;
    for (k in d) {
      s = s.replace(new RegExp("{" + k + "}", 'g'), d[k]);
    }
    return s;
  };

  return FieldValidator;

})();
