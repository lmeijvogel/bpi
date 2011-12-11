class this.Star
  constructor: (element, screen_size, offset_from_center, movement_distance) ->
    this.element = element
    this.offset_from_center = offset_from_center
    this.movement_distance = movement_distance

    this.screen_width = screen_size[0]
    this.screen_height = screen_size[1]

  display: ->
    this.position()

    motionTo = "easeOutQuad"
    motionFrom = "easeInQuad"

    time = 500

    this.element.animate({top:'-='+this.movement_distance}, time, motionTo)
    this.element.animate({top:'+='+this.movement_distance}, time, motionFrom)
    this.element.fadeOut()

  position: ->
    x = (this.screen_width - this.element.width()) / 2
    y = (this.screen_height - this.element.height()) / 2
    this.set_position(x+this.offset_from_center, y)
    this.element.show()

  set_position: (x, y) ->
    this.element.css('left', x)
    this.element.css('top', y)

