jQuery ->
  text = load_text()

  if text?
    upcoming_offset = 300
    text_server = new TextServer(text)

    screen_dimensions = [$(window).width(), $(window).height()]

    current_letter = new CurrentLetter($('#current_letter'), screen_dimensions)
    last_letter = new LastLetter($('#last_letter'), screen_dimensions, upcoming_offset)

    arrow = new Arrow($('#arrow'))
    typed_text = new TypedText($('#typed_text'), text)
    hint_text = new HintText($('#hint_text'), screen_dimensions)

    front_end = new FrontEnd( text_server, current_letter, last_letter, arrow, hint_text )
    front_end.letter_typed_callback = -> typed_text.next_letter()
    front_end.start_game()

    register_keypresses(text_server, front_end)

load_text = ->
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
