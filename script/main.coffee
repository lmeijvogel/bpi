class Main
  constructor: ->
    $.ajax(
        url: 'settings.json',
        async: false,
        dataType: 'json',
        success: (data) =>
          this.settings = data
    )

  start: ->
    text = this.load_text()

    if text?
      text_server = new TextServer(text)

      screen_dimensions = [$(window).width(), $(window).height()]

      current_letter = new CurrentLetter($('#current_letter'), screen_dimensions)
      last_letter = new LastLetter($('#last_letter'), screen_dimensions, this.settings.last_letter_slide_distance)

      incoming_logo = new IncomingLogo($('#incoming_logo'))
      first_star = new Star($('#first_star'), screen_dimensions, [0,0], this.settings.star_distance)
      second_star = new Star($('#second_star'), screen_dimensions, [15,0], this.settings.star_distance)

      arrow = new Arrow($('#arrow'), screen_dimensions, this.settings.arrow_start_position, this.settings.arrow_movement_distance, this.settings.arrow_timeout)
      typed_text = new TypedText($('#typed_text'), screen_dimensions, text)
      hint_text = new HintText($('#hint_text'), screen_dimensions, this.settings.hint_text_timeout)

      congratulations = new Congratulations($('#congratulations'), screen_dimensions, [0, -40])

      timer = new Timer($('#timer'), text, screen_dimensions)

      front_end = new FrontEnd( text_server, current_letter, last_letter, typed_text, incoming_logo, first_star, second_star, arrow, hint_text, congratulations, timer, this.settings.triggers )

      if (this.settings.fade_background)
        $.doTimeout( this.settings.fade_background_timeout, =>
          $('#canvas').fadeIn('slow')
          $('#blind').fadeIn('slow')

          this.start_game(text_server, front_end)
        )
      else
        $('#canvas').show()
        this.start_game(text_server, front_end)

  load_text: ->
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

  start_game: (text_server, front_end) ->
    $.doTimeout( this.settings.start_game_timeout, =>
      this.register_keypresses(text_server, front_end)

      front_end.start_game()
    )

  register_keypresses: (text_server, front_end) ->
    $(window).keypress( (event) ->
      front_end.key_pressed( event.charCode, event.keyCode )
    )

jQuery ->
  main = new Main()
  main.start()
