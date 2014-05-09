class PasswordValidation

  constructor: (@el, @validations) ->

  validations:
    length: 0
    lowercase: false
    uppercase: false
    numbers: false
    symbols: false
    includes: []
    excludes: []

  matchers:
    lowercase: /[a-z]/
    uppercase: /[A-Z]/
    numbers: /[0-9]/
    symbols: /[^a-zA-Z\d\s]/

  validate: ->
    value  = @el.value
    errors = []

    # Test length
    if @validations.length
      unless value.length >= @validations.length
        errors.push 'length'

    # Test matchers
    _.each @matchers, (regex, validation) =>
      if @validations[validation]
        unless @defaultRegex(@validations[validation], regex).test(value)
          errors.push validation

    # Test includes
    includes_errors = _.compact _.map @validations.includes, (requirement) ->
      requirement unless _.contains value, requirement
    errors.push include: includes_errors if includes_errors.length

    # Test excludes
    excludes_errors = _.compact _.map @validations.excludes, (requirement) ->
      requirement if _.contains value, requirement
    errors.push exclude: excludes_errors if excludes_errors.length

    errors if errors.length

  defaultRegex: (regex, fallback) ->
    if regex instanceof RegExp
      regex
    else
      return fallback
