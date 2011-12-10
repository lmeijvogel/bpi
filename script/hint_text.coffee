class this.HintText
  constructor: (element, screen_size, display_timeout) ->
    this.element = element
    this.screen_width = screen_size[0]
    this.screen_height = screen_size[1]
    this.display_timeout = display_timeout

  set: ->
    this.position()
    this.set_timeout()

  cancel: ->
    this.shouldShow = false
    this.hide()

  show: ->
    unless this.shouldShow
      return

    this.element.fadeIn()

  hide: ->
    this.element.fadeOut()

  position: ->
    x = (this.screen_width - this.element.width()) / 2
    y = (this.screen_height - this.element.height()) / 2
    this.element.css('top', y + 100)
    this.element.css('left', x)

  set_timeout: ->
    this.shouldShow = true

    $.doTimeout( this.display_timeout, =>
      this.show()
    )

