class this.Letter
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

  stop: ->
    this.element.stop()

class this.CurrentLetter extends Letter
  set_error: ->
    this.element.addClass('error')

  position: (screen_width, screen_height) ->
    x = (screen_width - this.element.width()) / 2
    y = (screen_height - this.element.height()) / 2
    this.set_position(x, y)

class this.UpcomingLetter extends Letter
  constructor: (element, upcoming_offset) ->
    super(element)
    this.upcoming_offset = upcoming_offset

  position: (screen_width, screen_height) ->
    x = (screen_width - this.element.width()) / 2
    y = (screen_height - this.element.height()) / 2

    this.set_position(x + this.upcoming_offset, y)


