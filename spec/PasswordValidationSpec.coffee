input      = document.createElement('input')
input.type = 'password'

describe 'validations', ->
  it "length", ->
    pv = new PasswordValidation input, length: 6
    expect(pv.validate()).toContain 'length'

  it "lowercase", ->
    input.value = 'HATMUFFIN'
    pv = new PasswordValidation input, lowercase: true
    expect(pv.validate()).toEqual ['lowercase']

  it "uppercase", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input, uppercase: true
    expect(pv.validate()).toEqual ['uppercase']

  it "numbers", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input, numbers: true
    expect(pv.validate()).toEqual ['numbers']

  it "symbols", ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input, symbols: true
    expect(pv.validate()).toEqual ['symbols']

describe 'custom validations', ->
  it "symbols", ->
    input.value = '&hatmuffin'
    pv = new PasswordValidation input, symbols: /[\W_]/
    expect(pv.validations.symbols).toEqual /[\W_]/

describe 'includes', ->
  it 'must include "hat"', ->
    input.value = 'muffin'
    pv = new PasswordValidation input, includes: ['hat']
    expect(pv.validate()).toContain { include: ['hat'] }

describe 'excluded', ->
  it 'must exclude "hat"', ->
    input.value = 'hatmuffin'
    pv = new PasswordValidation input, excludes: ['hat']
    expect(pv.validate()).toContain { exclude: ['hat'] }

describe 'valid password', ->
  it "is valid", ->
    input.value = '_9hatMuffins!'
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
