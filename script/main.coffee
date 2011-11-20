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
      front_end.set_next_letter( text_server )
      $('#current_letter').removeClass('error')
    else
      $('#current_letter').addClass('error')
  )

class FrontEnd
  constructor: (upcoming_offset) ->
    this.animating = false
    this.current_letter = $('#current_letter')
    this.upcoming_letter = $('#upcoming_letter')

    this.upcoming_offset = upcoming_offset

  position_letters: ->
    width = $(window).width()
    height = $(window).height()

    x = (width - this.current_letter.width()) / 2
    y = (height - this.current_letter.height()) / 2

    this.current_letter.css('left', x)
    this.current_letter.css('top', y)

    this.upcoming_letter.css('left', x + this.upcoming_offset)
    this.upcoming_letter.css('top', y)

    this.current_letter.show()
    this.upcoming_letter.hide()

  initialize_letters: (text_server) ->
    this.set_letter( this.current_letter, text_server.current_letter() )

  set_next_letter: (text_server) ->
    if this.animating
      this.set_letter( this.current_letter, text_server.current_letter() )
      this.position_letters

    next_letter = text_server.next_letter()
    this.set_letter( this.upcoming_letter, next_letter )

    this.current_letter.fadeOut( 'fast', =>
      this.set_letter( this.current_letter, next_letter )
    )

    this.slide_in_upcoming(this.upcoming_letter, this.current_letter)

  set_letter: (letter_div, letter) ->
    visible_letter = letter

    if letter == ' '
      visible_letter = 'spatie'
    else if letter == "\n"
      visible_letter = 'enter'

    if visible_letter.length > 1
      letter_div.addClass('small')
    else
      letter_div.removeClass('small')

    letter_div.text(visible_letter)

  slide_in_upcoming: (upcoming_letter_div, current_letter_div) ->
    this.animating = true

    upcoming_letter_div.css( 'display', 'block' )
    upcoming_letter_div.show()
    upcoming_letter_div.animate
      left: '-='+ this.upcoming_offset
      200
      =>
        this.position_letters()
        this.animating = false

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
