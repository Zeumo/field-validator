class FieldValidator

  constructor: (@el, validations = {}) ->
    @el = @el[0] if @el.jquery
    @setValidations(validations)

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

  messagePrefixes:
    include: "Do use"
    exclude: "Don't use"

  validate: ->
    status =
      errors: {
        include: @validateType('include')
        exclude: @validateType('exclude')
      }
      messages: []
      fullMessages: []
      toList: @toList

    errors = status.errors

    errors.include = _.compact _.flatten errors.include
    errors.exclude = _.compact _.flatten errors.exclude

    status.valid = !errors.include.length and !errors.exclude.length

    status.errors       = errors
    status.messages     = @createMessages(status)
    status.fullMessages = @createFullMessages(status)

    status

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
    if @validations[type][validation]
      if type == 'include'
        unless @_matchers[validation].test(value)
          return validation

      if type == 'exclude'
        if @_matchers[validation].test(value)
          return validation

  createFullMessages: (status) ->
    _.flatten _.map status.errors, (set, type) =>
      prefix = @messagePrefixes[type]

      _.map set, (validation) =>
        body = @template @_messages[validation], @validations[type]
        [prefix, body].join(' ')

  createMessages: (status) ->
    _.flatten _.map status.errors, (set, key) =>
      _.map set, (req) =>
        @template @_messages[req], @validations[key]

  setValidations: (object) ->
    unless @validations
      @validations = _.clone @_validations

    _.extend @validations, object
    @setMatchers()
    @setMessages()

  setMessages: ->
    # Copy validations to messages
    _.each @validations, (set, type) =>
      _.each set, (v, k) =>
        unless typeof v != 'string' or (/length/i).test k
          @_messages[k] = "#{k.replace('_', ' ')}: #{v}"

  setMatchers: ->
    # Copy validations to matchers
    _.each @validations, (set) =>
      _.each set, (val, validation) =>
        if typeof val == 'string'
          @_matchers[validation] = val

    # Convert strings to regex
    _.each @_matchers, (v, k) =>
      if typeof v == 'string'
        @_matchers[k] = new RegExp v

      # Remove anything that isn't regex
      unless @_matchers[k] instanceof RegExp
        delete @_matchers[k]

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
