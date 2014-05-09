describe 'validations', ->
  input = null

  beforeEach ->
    input      = document.createElement('input')
    input.type = 'password'

  it "length", ->
    pv = new PasswordValidation input, length: 6
    expect(pv.validate()).toContain 'length'

  it "lowercase", ->
    input.value = 'HATMUFFIN'
    pv = new PasswordValidation input, lowercase: true
    expect(pv.validate()).toContain 'lowercase'

  it "uppercase", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input, uppercase: true
    expect(pv.validate()).toContain 'uppercase'

  it "numbers", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input, numbers: true
    expect(pv.validate()).toContain 'numbers'

  it "symbols", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input, symbols: true
    expect(pv.validate()).toContain 'symbols'

describe 'valid password', ->
  input = null

  beforeEach ->
    input      = document.createElement('input')
    input.type = 'password'

  it "is valid", ->
    input.value = '9hatMuffins!'
    pv = new PasswordValidation input,
      length: 6
      lowercase: true
      uppercase: true
      numbers: true
      symbols: true

    expect(pv.validate()).toEqual undefined

  it "is invalid", ->
    input.value = 'hat'
    pv = new PasswordValidation input,
      length: 6
      lowercase: true
      uppercase: true
      numbers: true
      symbols: true

    expect(pv.validate()).toEqual ['length', 'uppercase', 'numbers', 'symbols']
