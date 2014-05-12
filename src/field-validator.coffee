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
    maxLength: 'more than {maxLength} characters'
    lowercase: 'a lowercase letter'
    uppercase: 'an uppercase letter'
    numbers: 'a number'
    symbols: 'a symbol'

  messagePrefixes:
    include: "Do use"
    exclude: "Don't use"

  validate: ->
    status =
      errors:
        include: @validateType('include')
        exclude: @validateType('exclude')
      messages: []
      fullMessages: []
      toList: @toList

    status.valid        = !status.errors.include
                            .concat(status.errors.exclude).length
    status.messages     = @createMessages(status)
    status.fullMessages = @createFullMessages(status)
    status

  validateType: (type) ->
    value = @el.value

    _.compact _.map @validations[type], (v, k) =>
      if (/length/i).test k
        @validateLength(value, type, k)
      else
        @validateMatcher(value, type, k)

  validateLength: (value, type, k) ->
    length = @validations[type][k]
    return k if value.length <= length and k == 'minLength'
    return k if value.length >= length and k == 'maxLength'

  validateMatcher: (value, type, k) ->
    return k if !@_matchers[k].test(value) and type == 'include'
    return k if @_matchers[k].test(value) and type == 'exclude'

  createFullMessages: (status) ->
    _.flatten _.map status.errors, (set, type) =>
      prefix = @messagePrefixes[type]

      _.map set, (v) =>
        body = @template @_messages[v], @validations[type]
        [prefix, body].join(' ')

  createMessages: (status) ->
    _.flatten _.map status.errors, (set, type) =>
      _.map set, (req) =>
        @template @_messages[req], @validations[type]

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
        if typeof v == 'string' and !(/length/i).test(k)
          @_messages[k] = "#{k.replace('_', ' ')}: #{v}"

  setMatchers: ->
    # Copy validations to matchers
    _.each @validations, (set) =>
      _.each set, (v, k) =>
        if typeof v == 'string'
          @_matchers[k] = v

    # Convert strings to regex
    _.each @_matchers, (v, k) =>
      if typeof v == 'string'
        @_matchers[k] = new RegExp v

  toList: (messageType) ->
    $list = document.createElement('ul')
    $list.className = 'error-messages'

    _.each this[messageType], (message) ->
      item = document.createElement('li')
      item.innerHTML = message
      $list.appendChild item

    $list

  template: (s, d) ->
    for k of d
      s = s.replace(new RegExp("{#{k}}", 'g'), d[k])
    s
