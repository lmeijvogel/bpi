jQuery ->
  text = load_text()

  fade_background = false
  fade_background_timeout = 2000

  start_game_timeout = 2000
  last_letter_slide_distance = 300

  arrow_timeout = 2000
  arrow_movement_distance = 5
  hint_text_timeout = 5000

  if text?
    text_server = new TextServer(text)

    screen_dimensions = [$(window).width(), $(window).height()]

    current_letter = new CurrentLetter($('#current_letter'), screen_dimensions)
    last_letter = new LastLetter($('#last_letter'), screen_dimensions, last_letter_slide_distance)

    arrow = new Arrow($('#arrow'), arrow_timeout, arrow_movement_distance)
    typed_text = new TypedText($('#typed_text'), text)
    hint_text = new HintText($('#hint_text'), screen_dimensions, hint_text_timeout)

    front_end = new FrontEnd( text_server, current_letter, last_letter, arrow, hint_text )
    front_end.letter_typed_callback = -> typed_text.next_letter()

    if (fade_background)
      $.doTimeout( fade_background_timeout, ->
        $('#blind').fadeIn('slow')

        $.doTimeout( start_game_timeout, ->
          register_keypresses(text_server, front_end)

          front_end.start_game()
        )
      )
    else
      $.doTimeout( start_game_timeout, ->
        register_keypresses(text_server, front_end)

        front_end.start_game()
      )


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
