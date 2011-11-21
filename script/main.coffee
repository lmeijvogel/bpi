jQuery ->
  text = load_text()

  if text?
    upcoming_offset = 300
    text_server = new TextServer(text)
    front_end = new FrontEnd( upcoming_offset )

    front_end.initialize_letters(text_server)
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
    is_correct = false
    current_letter = text_server.current_letter()

    entered_letter = String.fromCharCode(event.charCode)
    pressed_key = event.keyCode

    switch pressed_key
      when 13 then is_correct = current_letter == "\n"
      when 116 then return
      when 27 then return
      else
        is_correct = entered_letter == current_letter

    if is_correct
      front_end.letter_typed( text_server )
    else
      front_end.set_error()
  )

class FrontEnd
  constructor: (upcoming_offset) ->
    this.animating = false
    this.current_letter = new CurrentLetter($('#current_letter'))
    this.upcoming_letter = new UpcomingLetter($('#upcoming_letter'), upcoming_offset)

  position_letters: ->
    width = $(window).width()
    height = $(window).height()

    this.current_letter.position( width, height )
    this.upcoming_letter.position( width, height )

    this.current_letter.show()
    this.upcoming_letter.hide()

  initialize_letters: (text_server) ->
    this.current_letter.set( text_server.current_letter() )

  letter_typed: (text_server) ->
    if this.animating
      this.current_letter.set( text_server.current_letter() )
      this.position_letters

    next_letter = text_server.next_letter()
    this.upcoming_letter.set( next_letter )

    this.current_letter.element.fadeOut( 'fast', =>
      this.current_letter.set( next_letter )
    )

    this.slide_in_upcoming(this.upcoming_letter, this.current_letter)

  slide_in_upcoming: (upcoming_letter, current_letter) ->
    this.animating = true

    upcoming_letter.show()
    upcoming_letter.element.animate
      left: '-='+ this.upcoming_letter.upcoming_offset
      200
      =>
        this.position_letters()
        this.animating = false

  set_error: ->
    this.current_letter.set_error()

class Letter
  constructor: (element) ->
    this.element = element

  set_position: (x, y) ->
    this.element.css('left', x)
    this.element.css('top', y)

  set: (letter) ->
    visible_letter = letter

    if letter == ' '
      visible_letter = 'spatie'
    else if letter == "\n"
      visible_letter = 'enter'

    if visible_letter.length > 1
      this.element.addClass('small')
    else
      this.element.removeClass('small')

    this.element.removeClass('error')
    this.element.text(visible_letter)

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

  next_letter: ->
    this.current_index++
    letter = this.current_letter()

    letter
