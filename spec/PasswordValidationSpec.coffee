input      = document.createElement('input')
input.type = 'password'

describe 'validations (includes)', ->
  it "length", ->
    pv = new PasswordValidation input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.requirements).toEqual include: [ 'minLength' ]

  it "lowercase", ->
    input.value = 'HATMUFFIN'
    pv = new PasswordValidation input,
      include:
        lowercase: true

    errors = pv.validate()
    expect(errors.requirements).toEqual include: ['lowercase']

  it "uppercase", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input,
      include:
        uppercase: true

    errors = pv.validate()
    expect(errors.requirements).toEqual include: ['uppercase']

  it "numbers", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input,
      include:
        numbers: true

    errors = pv.validate()
    expect(errors.requirements).toEqual include: ['numbers']

  it "symbols", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input,
      include:
        symbols: true

    errors = pv.validate()
    expect(errors.requirements).toEqual include: ['symbols']

describe 'validations (excludes)', ->
  it "length", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input,
      exclude:
        maxLength: 2

    errors = pv.validate()
    expect(errors.requirements).toEqual exclude: [ 'maxLength' ]

  it "lowercase", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input,
      exclude:
        lowercase: true

    errors = pv.validate()
    expect(errors.requirements).toEqual exclude: ['lowercase']

  it "uppercase", ->
    input.value = 'HATMUFFIN'
    pv = new PasswordValidation input,
      exclude:
        uppercase: true

    errors = pv.validate()
    expect(errors.requirements).toEqual exclude: ['uppercase']

  it "numbers", ->
    input.value = 'hatmuFFin!1101'
    pv = new PasswordValidation input,
      exclude:
        numbers: true

    errors = pv.validate()
    expect(errors.requirements).toEqual exclude: ['numbers']

  it "symbols", ->
    input.value = 'hatmuffin!_'
    pv = new PasswordValidation input,
      exclude:
        symbols: true

    errors = pv.validate()
    expect(errors.requirements).toEqual exclude: ['symbols']

describe 'custom validations', ->
  it "symbols", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input,
      include:
        symbols: /[#]/

    errors = pv.validate()
    expect(errors.requirements).toEqual include: ['symbols']
    expect(errors.fullMessages).toEqual ["Please use a symbol"]

  it "email", ->
    input.value = 'hatmuffin!name'
    pv = new PasswordValidation input,
      exclude:
        partial_email: 'name'

    errors = pv.validate()
    expect(errors.requirements).toEqual exclude: ['partial_email']
    expect(errors.fullMessages).toEqual ["Please don't use partial email: name"]

describe 'valid password', ->
  it "is valid", ->
    input.value = '_9hatMuffins!'
    pv = new PasswordValidation input,
      include:
        minLength: 6
        lowercase: true
        uppercase: true
        numbers: true
        symbols: true

    errors = pv.validate()
    expect(errors.requirements).toEqual {}

  it "is invalid", ->
    input.value = 'hat'
    pv = new PasswordValidation input,
      include:
        minLength: 6
        lowercase: true
        uppercase: true
        numbers: true
        symbols: true

    errors = pv.validate()
    expect(errors.requirements).toEqual include: ['minLength', 'uppercase', 'numbers', 'symbols']

describe 'errors', ->
  it 'has requirements', ->
    input.value = ''
    pv = new PasswordValidation input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.requirements).toEqual include: ['minLength']

  it 'has messages', ->
    input.value = ''
    pv = new PasswordValidation input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.messages).toEqual ['at least 6 characters']

  it 'has fullMessages', ->
    input.value = ''
    pv = new PasswordValidation input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.fullMessages).toEqual ['Please use at least 6 characters']

  it 'can create list from messages', ->
    input.value = ''
    pv = new PasswordValidation input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.toList('fullMessages').outerHTML).toEqual "
      <ul class=\"error-messages\"><li>Please use at least 6 characters</li></ul>
    "
