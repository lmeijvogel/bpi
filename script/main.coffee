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
