class this.Letter
  constructor: (element, screen_size) ->
    this.element = element
    this.screen_width = screen_size[0]
    this.screen_height = screen_size[1]

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

  stop: ->
    this.element.stop()

class this.CurrentLetter extends Letter
  set_error: ->
    this.element.addClass('error')

  position: ->
    x = (this.screen_width - this.element.width()) / 2
    y = (this.screen_height - this.element.height()) / 2
    this.set_position(x, y)
    this.show()

  next_letter: (letter) ->
    this.element.fadeOut( 'fast', =>
      this.set( letter )
    )

class this.UpcomingLetter extends Letter
  constructor: (element, screen_size, upcoming_offset) ->
    super(element, screen_size)
    this.upcoming_offset = upcoming_offset

  position: ->
    x = (this.screen_width - this.element.width()) / 2
    y = (this.screen_height - this.element.height()) / 2

    this.set_position(x + this.upcoming_offset, y)
    this.hide()

  next_letter: (letter, callback) ->
    this.set(letter)
    this.slide_in(callback)

  slide_in: (callback) ->
    this.show()
    this.element.animate
      left: '-='+ this.upcoming_offset
      200
      =>
        callback.call()
