class Main
  constructor: ->
    this.fade_background = false
    this.fade_background_timeout = 2000
    this.start_game_timeout = 2000
    this.last_letter_slide_distance = 300

    this.star_distance = 80
    this.arrow_timeout = 10
    this.arrow_start_position = 60
    this.arrow_movement_distance = 5
    this.hint_text_timeout = 5000

  start: ->
    text = this.load_text()

    if text?
      text_server = new TextServer(text)

      screen_dimensions = [$(window).width(), $(window).height()]

      current_letter = new CurrentLetter($('#current_letter'), screen_dimensions)
      last_letter = new LastLetter($('#last_letter'), screen_dimensions, this.last_letter_slide_distance)

      incoming_logo = new IncomingLogo($('#incoming_logo'))
      first_star = new Star($('#first_star'), screen_dimensions, [0,0], this.star_distance)
      second_star = new Star($('#second_star'), screen_dimensions, [15,0], this.star_distance)

      arrow = new Arrow($('#arrow'), screen_dimensions, this.arrow_start_position, this.arrow_movement_distance, this.arrow_timeout)
      typed_text = new TypedText($('#typed_text'), screen_dimensions, text)
      hint_text = new HintText($('#hint_text'), screen_dimensions, this.hint_text_timeout)

      congratulations = new Congratulations($('#congratulations'), screen_dimensions, [0, -40])

      front_end = new FrontEnd( text_server, current_letter, last_letter, typed_text, incoming_logo, first_star, second_star, arrow, hint_text, congratulations )

      if (this.fade_background)
        $.doTimeout( this.fade_background_timeout, =>
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
    $.doTimeout( this.start_game_timeout, =>
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
