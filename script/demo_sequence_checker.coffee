class this.DemoSequenceChecker
  constructor: (text) ->
    this.letters = text.split('')
    this.expected_position = 0

  letter_pressed: (letter) ->
    if letter == this.expected_letter()
      this.expected_position++
    else
      this.expected_position = 0

  expected_letter: ->
    this.letters[this.expected_position]

  complete: ->
    this.expected_position == this.letters.length
