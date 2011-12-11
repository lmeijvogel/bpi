class this.CenteredElement
  constructor: (element, screen_size, offset_from_center) ->
    this.element = element
    this.offset_from_center = offset_from_center

    this.screen_width = screen_size[0]
    this.screen_height = screen_size[1]

  position: ->
    x = (this.screen_width - this.element.width()) / 2
    y = (this.screen_height - this.element.height()) / 2
    this.set_position(x+this.offset_from_center, y)
    this.element.show()

  set_position: (x, y) ->
    this.element.css('left', x)
    this.element.css('top', y)

