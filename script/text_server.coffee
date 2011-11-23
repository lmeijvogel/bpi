class this.TextServer
  constructor: (loaded_text) ->
    this.loaded_text = loaded_text
    this.current_index = 0

  current_letter: ->
    this.loaded_text[this.current_index]

  has_more_letters: ->
    this.current_index < this.loaded_text.length - 1

  next_letter: ->
    this.current_index++
    letter = this.current_letter()

    letter

