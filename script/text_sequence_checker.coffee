class this.TextSequenceChecker
  constructor: (text, complete_callback) ->
    this.letters = text.split('')
    this.complete_callback = complete_callback

    this.expected_position = 0

  letter_pressed: (letter) ->
    if letter == this.expected_letter()
      this.expected_position++

      if this.complete()
        this.complete_callback.call()
    else
      this.expected_position = 0

  expected_letter: ->
    this.letters[this.expected_position]

  complete: ->
    this.expected_position == this.letters.length
