class this.FrontEnd
  constructor: (text_server, current_letter, last_letter, arrow, hint_text) ->
    this.animating = false

    this.game_completed = false

    this.text_server = text_server

    this.current_letter = current_letter
    this.last_letter = last_letter
    this.arrow = arrow
    this.hint_text = hint_text

    this.text_sequence_checker = new TextSequenceChecker('doededemo')

  start_game: ->
    this.initialize_letters()
    this.position_letters()

    this.set_hints()

  position_letters: ->
    this.current_letter.position()
    this.last_letter.position()

  initialize_letters: ->
    this.current_letter.set( this.text_server.current_letter() )
    this.current_letter.appear()

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
    this.cancel_hints()

    return if this.game_completed

    is_correct = false
    current_letter = this.text_server.current_letter()

    entered_letter = String.fromCharCode(charCode)
    pressed_key = keyCode

    this.check_text_sequence(entered_letter)
    if entered_letter == current_letter
      is_correct = true
    else
      switch pressed_key
        when 27, 116, 192 then return # escape, F5, alt-tab
        when 13 then is_correct = current_letter == "\n"
        else
          is_correct = false

    if is_correct
      this.letter_typed( this.text_server )
    else
      this.set_error()

  set_hints: ->
    this.arrow.set()
    this.hint_text.set()

  cancel_hints: ->
    this.arrow.cancel()
    this.hint_text.cancel()

  check_text_sequence: (entered_letter) ->
    this.text_sequence_checker.letter_pressed(entered_letter)

    if this.text_sequence_checker.complete()
      this.run_demo()

  run_demo: ->
    $.doTimeout(200, =>
      this.letter_typed( this.text_server )

      return !$('#congratulations').is(':visible')
    )

  set_error: ->
    this.current_letter.set_error()
