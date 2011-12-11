class this.Star extends CenteredElement
  constructor: (element, screen_size, offset_from_center, movement_distance) ->
    super( element, screen_size, offset_from_center )
    this.movement_distance = movement_distance

  display: ->
    this.position()

    motionTo = "easeOutQuad"
    motionFrom = "easeInQuad"

    time = 500

    this.element.animate({top:'-='+this.movement_distance}, time, motionTo)
    this.element.animate({top:'+='+this.movement_distance}, time, motionFrom)
    this.element.fadeOut()
