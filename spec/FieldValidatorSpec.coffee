input      = document.createElement('input')
input.type = 'password'

describe 'arguments', ->
  it 'accepts a DOM object', ->
    f = new FieldValidator input,
      include:
        minLength: 6
    expect( -> f.validate() ).not.toThrow()

  it 'accepts a jQuery object', ->
    $input = $('<input>')
    f = new FieldValidator $input,
      include:
        minLength: 6
    expect( -> f.validate() ).not.toThrow()

describe 'validations (includes)', ->
  it "length", ->
    pv = new FieldValidator input,
      include:
        minLength: 6

    status = pv.validate()
    expect(status.errors.include).toEqual [ 'minLength' ]

  it "lowercase", ->
    input.value = 'HATMUFFIN'
    pv = new FieldValidator input,
      include:
        lowercase: true

    status = pv.validate()
    expect(status.errors.include).toEqual ['lowercase']

  it "uppercase", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      include:
        uppercase: true

    status = pv.validate()
    expect(status.errors.include).toEqual ['uppercase']

  it "numbers", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      include:
        numbers: true

    status = pv.validate()
    expect(status.errors.include).toEqual ['numbers']

  it "symbols", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      include:
        symbols: true

    status = pv.validate()
    expect(status.errors.include).toEqual ['symbols']

describe 'validations (excludes)', ->
  it "length", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      exclude:
        maxLength: 2

    status = pv.validate()
    expect(status.errors.exclude).toEqual ['maxLength']

  it "lowercase", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      exclude:
        lowercase: true

    status = pv.validate()
    expect(status.errors.exclude).toEqual ['lowercase']

  it "uppercase", ->
    input.value = 'HATMUFFIN'
    pv = new FieldValidator input,
      exclude:
        uppercase: true

    status = pv.validate()
    expect(status.errors.exclude).toEqual ['uppercase']

  it "numbers", ->
    input.value = 'hatmuFFin!1101'
    pv = new FieldValidator input,
      exclude:
        numbers: true

    status = pv.validate()
    expect(status.errors.exclude).toEqual ['numbers']

  it "symbols", ->
    input.value = 'hatmuffin!_'
    pv = new FieldValidator input,
      exclude:
        symbols: true

    status = pv.validate()
    expect(status.errors.exclude).toEqual ['symbols']

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

    status = pv.validate()
    expect(status.valid).toBe true

  it "is invalid", ->
    input.value = 'hat'
    pv = new FieldValidator input,
      include:
        minLength: 6
        lowercase: true
        uppercase: true
        numbers: true
        symbols: true

    status = pv.validate()
    expect(status.valid).toBe false
    expect(status.errors.include).toEqual ['minLength', 'uppercase', 'numbers', 'symbols']

describe 'errors', ->
  it 'has requirements', ->
    input.value = ''
    pv = new FieldValidator input,
      include:
        minLength: 6

    status = pv.validate()
    expect(status.errors.include).toEqual ['minLength']

  it 'has messages', ->
    input.value = ''
    pv = new FieldValidator input,
      include:
        minLength: 6

    status = pv.validate()
    expect(status.messages).toEqual ['at least 6 characters']

  it 'has fullMessages', ->
    input.value = ''
    pv = new FieldValidator input,
      include:
        minLength: 6

    status = pv.validate()
    expect(status.fullMessages).toEqual ['Do use at least 6 characters']

  it 'can create list from messages', ->
    input.value = ''
    pv = new FieldValidator input,
      include:
        minLength: 6

    status = pv.validate()
    expect(status.toList('fullMessages').outerHTML).toEqual "
      <ul class=\"error-messages\"><li>Do use at least 6 characters</li></ul>
    "

describe 'custom validations', ->
  it "symbols", ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      include:
        symbols: /[#]/

    status = pv.validate()
    expect(status.errors.include).toEqual ['symbols']
    expect(status.fullMessages).toEqual ["Do use a symbol"]

  it "email", ->
    input.value = 'hatmuffin!name'
    pv = new FieldValidator input,
      include:
        uppercase: true
      exclude:
        partial_email: 'name'

    status = pv.validate()
    expect(status.errors.include).toEqual ['uppercase']
    expect(status.errors.exclude).toEqual ['partial_email']
    expect(status.fullMessages).toEqual [
      "Do use an uppercase letter"
      "Don't use partial email: name"
    ]

describe 'setting validations', ->
  it 'supports setting validations after init', ->
    input.value = 'hatmuffin'
    pv = new FieldValidator input,
      include:
        minLength: 6

    status = pv.validate()
    expect(status.errors.include).toEqual []

    pv.setValidations
      exclude:
        lowercase: true

    status = pv.validate()
    expect(status.errors.exclude).toEqual ['lowercase']

