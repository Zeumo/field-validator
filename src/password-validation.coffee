class PasswordValidation

  constructor: (@el, validations = {}) ->
    @validations = _.defaults validations, @_validations

  _validations:
    include:
      minLength: 0
      lowercase: false
      uppercase: false
      numbers: false
      symbols: false

  _matchers:
    lowercase: /[a-z]/
    uppercase: /[A-Z]/
    numbers: /[0-9]/
    symbols: /[^a-zA-Z\d\s]/

  _messages:
    minLength: 'at least {minLength} characters'
    maxLength: 'shorter than {minLength} characters'
    lowercase: 'a lowercase letter'
    uppercase: 'an uppercase letter'
    numbers: 'a number'
    symbols: 'a symbol'

  validate: ->
    value  = @el.value
    errors =
      requirements: {
        include: @validateType('include')
        exclude: @validateType('exclude')
      }
      messages: []
      fullMessages: []
      toList: @toList

    errors.requirements.include = _.compact _.flatten errors.requirements.include
    errors.requirements.exclude = _.compact _.flatten errors.requirements.exclude

    delete errors.requirements.include if _.isEmpty errors.requirements.include
    delete errors.requirements.exclude if _.isEmpty errors.requirements.exclude

    errors.messages     = @createMessages(errors.requirements)
    errors.fullMessages = @createFullMessages(errors.messages)

    errors

  validateType: (type) ->
    value = @el.value

    _.map @validations[type], (re, validation) =>
      if (/length/i).test validation
        @validateLength(value, type)
      else
        @validateMatcher(value, type, validation)

  validateLength: (value, type) ->
    if type == 'include'
      validation = 'minLength'
      if length = @validations[type][validation]
        unless value.length >= length
          return validation

    if type == 'exclude'
      validation = 'maxLength'
      if length = @validations[type][validation]
        if value.length >= length
          return validation

  validateMatcher: (value, type, validation) ->
    if v = @validations[type][validation]
      if type == 'include'
        unless @defaultRegex(v, @_matchers[validation]).test(value)
          return validation

      if type == 'exclude'
        if @defaultRegex(v, @_matchers[validation]).test(value)
          return validation

  validateExcludes: (value) ->
    excludes = _.compact _.map _.keys(@validations), (key) ->
      key if /^exclude/.test key

    validations = _.map excludes, (key) =>
      @validations[key]

    _.map validations, (validation) ->
      validation if _.contains value, validation

  defaultRegex: (regex, fallback) ->
    if regex instanceof RegExp
      return regex
    else
      return fallback

  createFullMessages: (messages) ->
    _.map messages, (message) ->
      "Please use #{message}"

  createMessages: (requirements) ->
    _.flatten _.map requirements, (set, key) =>
      _.map set, (req) =>
        @template @_messages[req], @validations[key]

  toList: (messageType) ->
    messages = this[messageType]
    $list = document.createElement('ul')
    $list.className = 'error-messages'

    _.each messages, (message) ->
      item = document.createElement('li')
      item.innerHTML = message
      $list.appendChild item

    $list

  template: (s, d) ->
    for p of d
      s = s.replace(new RegExp("{#{p}}", 'g'), d[p])
    s

  set: (k, v) ->
    this[k] = v
