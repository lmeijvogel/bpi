class this.FrontEnd
  constructor: (text_server, current_letter, last_letter, typed_text, incoming_logo, first_star, second_star, arrow, hint_text, congratulations, timer, triggers) ->
    this.animating = false

    this.game_completed = false

    this.text_server = text_server

    this.current_letter = current_letter
    this.last_letter = last_letter

    this.typed_text = typed_text

    this.first_star = first_star
    this.second_star = second_star
    this.incoming_logo = incoming_logo

    this.arrow = arrow
    this.hint_text = hint_text

    this.congratulations = congratulations

    this.letter_typed_callback = -> typed_text.next_letter()

    this.timer = timer

    # The difference between the demo sequence checker and the text sequence checkers is that the
    # text sequence checkers can only be triggered by valid characters, while the demo sequence checker
    # can only be triggered by invalid characters.
    #
    # Since demo mode just calls letter_typed repeatedly, the text sequences are checked there and not
    # in key_pressed(), otherwise they would not be triggered in demo mode.
    this.demo_sequence_checker = new TextSequenceChecker('doededemo', => this.run_demo() )

    if (triggers)
      this.text_sequence_checkers = [
        new TextSequenceChecker(triggers.first_star, => this.display_first_star() ),
        new TextSequenceChecker(triggers.second_star, => this.display_both_stars() )
        new TextSequenceChecker(triggers.logo, => this.display_incoming_logo() )
      ]

  start_game: ->
    this.initialize_letters()
    this.position_letters()
    this.position_typed_text()
    this.set_hints()

  position_letters: ->
    this.current_letter.position()
    this.last_letter.position()

  position_typed_text: ->
    this.typed_text.position()

  initialize_letters: ->
    this.current_letter.set( this.text_server.current_letter() )
    this.current_letter.appear()

  letter_typed: ->
    this.check_text_sequences( this.text_server.current_letter() )

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

    this.congratulations.show()
    this.timer.done()

  key_pressed: ( charCode, keyCode ) ->
    this.cancel_hints()
    this.timer.start_if_necessary()

    return if this.game_completed

    is_correct = false
    current_letter = this.text_server.current_letter()

    entered_letter = String.fromCharCode(charCode)
    pressed_key = keyCode

    this.check_demo_sequence(entered_letter)

    if entered_letter == current_letter
      is_correct = true
    else
      switch pressed_key
        when 27, 91, 116, 192, 9 then return # escape, <Windows>, F5, alt-tab, ctrl-tab
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

  check_demo_sequence: (entered_letter) ->
    this.demo_sequence_checker.letter_pressed(entered_letter)

  check_text_sequences: (entered_letter) ->
    for checker in this.text_sequence_checkers
      checker.letter_pressed(entered_letter)

  run_demo: ->
    $.doTimeout(100, =>
      this.letter_typed( this.text_server )

      return !$('#congratulations').is(':visible')
    )

  display_first_star: ->
    this.first_star.display()

  display_both_stars: ->
    this.first_star.display()
    $.doTimeout(200, =>
      this.second_star.display()
    )

  display_incoming_logo: ->
    this.incoming_logo.display()

  set_error: ->
    this.current_letter.set_error()
