input      = document.createElement('input')
input.type = 'password'

describe 'validations (includes)', ->
  it "length", ->
    pv = new FieldValidator input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.requirements.include).toEqual [ 'minLength' ]

  it "lowercase", ->
    input.value = 'HATMUFFIN'
    pv = new FieldValidator input,
      include:
        lowercase: true

    errors = pv.validate()
    expect(errors.requirements.include).toEqual ['lowercase']

  it "uppercase", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      include:
        uppercase: true

    errors = pv.validate()
    expect(errors.requirements.include).toEqual ['uppercase']

  it "numbers", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      include:
        numbers: true

    errors = pv.validate()
    expect(errors.requirements.include).toEqual ['numbers']

  it "symbols", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      include:
        symbols: true

    errors = pv.validate()
    expect(errors.requirements.include).toEqual ['symbols']

describe 'validations (excludes)', ->
  it "length", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      exclude:
        maxLength: 2

    errors = pv.validate()
    expect(errors.requirements.exclude).toEqual [ 'maxLength' ]

  it "lowercase", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      exclude:
        lowercase: true

    errors = pv.validate()
    expect(errors.requirements.exclude).toEqual ['lowercase']

  it "uppercase", ->
    input.value = 'HATMUFFIN'
    pv = new FieldValidator input,
      exclude:
        uppercase: true

    errors = pv.validate()
    expect(errors.requirements.exclude).toEqual ['uppercase']

  it "numbers", ->
    input.value = 'hatmuFFin!1101'
    pv = new FieldValidator input,
      exclude:
        numbers: true

    errors = pv.validate()
    expect(errors.requirements.exclude).toEqual ['numbers']

  it "symbols", ->
    input.value = 'hatmuffin!_'
    pv = new FieldValidator input,
      exclude:
        symbols: true

    errors = pv.validate()
    expect(errors.requirements.exclude).toEqual ['symbols']

describe 'valid password', ->
  it "is valid", ->
    input.value = '_9hatMuffins!'
    pv = new FieldValidator input,
      include:
        minLength: 6
        lowercase: true
        uppercase: true
        numbers: true
        symbols: true

    errors = pv.validate()
    expect(errors.valid).toBe true

  it "is invalid", ->
    input.value = 'hat'
    pv = new FieldValidator input,
      include:
        minLength: 6
        lowercase: true
        uppercase: true
        numbers: true
        symbols: true

    errors = pv.validate()
    expect(errors.valid).toBe false
    expect(errors.requirements.include).toEqual ['minLength', 'uppercase', 'numbers', 'symbols']

describe 'errors', ->
  it 'has requirements', ->
    input.value = ''
    pv = new FieldValidator input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.requirements.include).toEqual ['minLength']

  it 'has messages', ->
    input.value = ''
    pv = new FieldValidator input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.messages).toEqual ['at least 6 characters']

  it 'has fullMessages', ->
    input.value = ''
    pv = new FieldValidator input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.fullMessages).toEqual ['Do use at least 6 characters']

  it 'can create list from messages', ->
    input.value = ''
    pv = new FieldValidator input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.toList('fullMessages').outerHTML).toEqual "
      <ul class=\"error-messages\"><li>Do use at least 6 characters</li></ul>
    "

describe 'custom validations', ->
  it "symbols", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      include:
        symbols: /[#]/

    errors = pv.validate()
    expect(errors.requirements.include).toEqual ['symbols']
    expect(errors.fullMessages).toEqual ["Do use a symbol"]

  it "email", ->
    input.value = 'hatmuffin!name'
    pv = new FieldValidator input,
      include:
        uppercase: true
      exclude:
        partial_email: 'name'

    errors = pv.validate()
    expect(errors.requirements.include).toEqual ['uppercase']
    expect(errors.requirements.exclude).toEqual ['partial_email']
    expect(errors.fullMessages).toEqual [
      "Do use an uppercase letter"
      "Don't use partial email: name"
    ]

describe 'setting validations', ->
  it 'supports setting validations after init', ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      include:
        minLength: 6

    errors = pv.validate()
    expect(errors.requirements.include).toEqual []

    pv.setValidations
      exclude:
        lowercase: true

    errors = pv.validate()
    expect(errors.requirements.exclude).toEqual ['lowercase']

