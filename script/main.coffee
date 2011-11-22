jQuery ->
  text = load_text()

  if text?
    upcoming_offset = 300
    text_server = new TextServer(text)
    front_end = new FrontEnd( text_server, upcoming_offset )

    front_end.initialize_letters()
    front_end.position_letters()

    register_keypresses(text_server, front_end)

load_text = ->
  $('#notice').text("Bezig met laden")
  $('#notice').show()

  result = null

  # Perform request synchronously so a value can be returned
  $.ajax "content/contents.txt",
    type: "GET",
    async: false,
    success: (jqXHR) ->
      result = jqXHR
      $('#notice').hide()
    error: ->
      $('#notice').text("Lennaert heeft een fout gemaakt!")
      $('#notice').show()

  result

register_keypresses = (text_server, front_end) ->
  $(window).keypress( (event) ->
    front_end.key_pressed( event.charCode, event.keyCode )
  )

class FrontEnd
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

class Letter
  constructor: (element) ->
    this.element = element

  set_position: (x, y) ->
    this.element.css('left', x)
    this.element.css('top', y)

  set: (letter) ->
    displayed_letter = letter

    if letter == ' '
      displayed_letter = 'spatie'
    else if letter == "\n"
      displayed_letter = 'enter'

    if displayed_letter.length > 1
      this.element.addClass('small')
    else
      this.element.removeClass('small')

    this.element.removeClass('error')
    this.element.text(displayed_letter)

  show: ->
    this.element.show()

  hide: ->
    this.element.hide()

class CurrentLetter extends Letter
  set_error: ->
    this.element.addClass('error')

  position: (screen_width, screen_height) ->
    x = (screen_width - this.element.width()) / 2
    y = (screen_height - this.element.height()) / 2
    this.set_position(x, y)

class UpcomingLetter extends Letter
  constructor: (element, upcoming_offset) ->
    super(element)
    this.upcoming_offset = upcoming_offset

  position: (screen_width, screen_height) ->
    x = (screen_width - this.element.width()) / 2
    y = (screen_height - this.element.height()) / 2

    this.set_position(x + this.upcoming_offset, y)

class TextServer
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
