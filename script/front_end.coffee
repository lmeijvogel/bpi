class this.FrontEnd
  constructor: (text_server, current_letter, last_letter) ->
    this.animating = false

    this.game_completed = false

    this.text_server = text_server

    this.current_letter = current_letter
    this.last_letter = last_letter

    this.demo_letter_index = -1

  start_game: ->
    this.initialize_letters()
    this.position_letters()

  position_letters: ->
    this.current_letter.position()
    this.last_letter.position()

  initialize_letters: ->
    this.current_letter.set( this.text_server.current_letter() )

  letter_typed: ->
    if this.text_server.has_more_letters()
      if this.animating
        this.last_letter.stop()
        this.position_letters()

      this.last_letter.next_letter( this.text_server.current_letter(), =>
        this.position_letters
        this.animating = false
      )

      next_letter = this.text_server.next_letter()

      this.animating = true
      this.current_letter.next_letter( next_letter )

      if this.letter_typed_callback
        this.letter_typed_callback.call()
    else
      this.finish_game()

  finish_game: ->
    this.game_completed = true
    this.last_letter.hide()
    this.current_letter.hide()

    $('#congratulations').show()

  key_pressed: ( charCode, keyCode ) ->
    return if this.game_completed

    is_correct = false
    current_letter = this.text_server.current_letter()

    entered_letter = String.fromCharCode(charCode)
    pressed_key = keyCode

    if entered_letter == current_letter
      is_correct = true
    else
      this.check_demo_sequence(entered_letter)

      switch pressed_key
        when 27, 116, 192 then return # escape, F5, alt-tab
        when 13 then is_correct = current_letter == "\n"
        else
          is_correct = false

    if is_correct
      this.letter_typed( this.text_server )
    else
      this.set_error()

  check_demo_sequence: (entered_letter) ->
    letters = ['d','e','m','o']

    expected_letter = letters[this.demo_letter_index + 1]

    if entered_letter == expected_letter
      this.demo_letter_index++


      if this.demo_letter_index == 3
        this.run_demo()
    else
      this.demo_letter_index = -1

  run_demo: ->
    $.doTimeout(200, =>
      this.letter_typed( this.text_server )

      return !$('#congratulations').is(':visible')
    )

  set_error: ->
    this.current_letter.set_error()
