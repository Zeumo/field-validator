class PasswordValidation

  constructor: (el, validations) ->
    @el          = el
    @validations = _.extend @validations, validations

  validations:
    length: 0
    lowercase: false
    uppercase: false
    numbers: false
    symbols: false
    includes: []
    excludes: []

  validate: ->
    value  = @el.value
    errors = []

    if @validations.length
      unless value.length >= @validations.length
        errors.push 'length'

    if @validations.lowercase
      unless /[a-z]/.test value
        errors.push 'lowercase'

    if @validations.uppercase
      unless /[A-Z]/.test value
        errors.push 'uppercase'

    if @validations.numbers
      unless /[0-9]/.test value
        errors.push 'numbers'

    if @validations.symbols
      unless /\W/.test value
        errors.push 'symbols'

    # includes
    # excludes

    errors if errors.length
