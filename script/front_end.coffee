class this.FrontEnd
  constructor: (text_server, upcoming_offset) ->
    this.animating = false

    this.game_completed = false

    this.text_server = text_server
    this.current_letter = new CurrentLetter($('#current_letter'))
    this.upcoming_letter = new UpcomingLetter($('#upcoming_letter'), upcoming_offset)

  position_letters: ->
    width = $(window).width()
    height = $(window).height()

    this.current_letter.position( width, height )
    this.upcoming_letter.position( width, height )

    this.current_letter.show()
    this.upcoming_letter.hide()

  initialize_letters: ->
    this.current_letter.set( this.text_server.current_letter() )

  letter_typed: ->
    if this.text_server.has_more_letters()
      if this.animating
        this.current_letter.set( this.text_server.current_letter() )
        this.position_letters

      next_letter = this.text_server.next_letter()
      this.upcoming_letter.set( next_letter )

      this.current_letter.element.fadeOut( 'fast', =>
        this.current_letter.set( next_letter )
      )

      this.slide_in_upcoming(this.upcoming_letter, this.current_letter)
    else
      this.finish_game()

  finish_game: ->
    this.game_completed = true
    $('#letters').hide()
    $('#congratulations').show()

  slide_in_upcoming: (upcoming_letter, current_letter) ->
    this.animating = true

    upcoming_letter.show()
    upcoming_letter.element.animate
      left: '-='+ this.upcoming_letter.upcoming_offset
      200
      =>
        this.position_letters()
        this.animating = false

  key_pressed: ( charCode, keyCode ) ->
    return if this.game_completed

    is_correct = false
    current_letter = this.text_server.current_letter()

    entered_letter = String.fromCharCode(charCode)
    pressed_key = keyCode

    switch pressed_key
      when 27, 116, 192 then return # escape, F5, alt-tab
      when 13 then is_correct = current_letter == "\n"
      else
        is_correct = entered_letter == current_letter

    if is_correct
      this.letter_typed( this.text_server )
    else
      this.set_error()

  set_error: ->
    this.current_letter.set_error()
