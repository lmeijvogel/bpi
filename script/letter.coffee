class this.Letter
  constructor: (element, screen_size) ->
    this.element = element
    this.screen_width = screen_size[0]
    this.screen_height = screen_size[1]

  appear: ->
    this.element.fadeIn(1000)

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

  position: ->
    x = (this.screen_width - this.element.width()) / 2
    y = (this.screen_height - this.element.height()) / 2
    this.set_position(x, y)
    this.show()

  show: ->
    this.element.show()

  hide: ->
    this.element.hide()

  stop: ->
    this.element.stop()

class this.CurrentLetter extends Letter
  set_error: ->
    this.element.addClass('error')

  next_letter: (letter) ->
    this.set( letter )

class this.LastLetter extends Letter
  constructor: (element, screen_size, slide_distance) ->
    super(element, screen_size)
    this.slide_distance = slide_distance

  position: ->
    super()
    this.element.css({ opacity: 1 })
    this.hide()

  slide_out: (callback) ->
    this.show()
    this.element.animate
      opacity: 0.25
      left: '-=' + this.slide_distance
      600
      =>
        this.hide()
        callback.call()

  next_letter: (letter, callback) ->
    this.set(letter)
    this.position()
    this.show()

    this.slide_out(callback)
