class this.Arrow extends CenteredElement
  constructor: (element, screen_size, start_position, movement_distance, display_timeout) ->
    super(element, screen_size, [-start_position,0])
    this.display_timeout = display_timeout
    this.movement_distance = movement_distance

  set: ->
    this.position_invisible()
    this.set_timeout()

  subtract_pixels: ( position, value ) ->
    position_text = position.replace("px", "")
    return position_text - value

  cancel: ->
    this.element.hide()
    this.shouldShow = false

  show: ->
    unless this.shouldShow
      return

    motionTo = 'easeInQuad'
    motionFrom = 'easeOutQuad'

    # "silently" move arrow back so it can point forward again.
    this.element.animate({left:'-='+this.movement_distance},0, motionFrom)
    this.element.fadeIn()
    for i in [0..3]
      this.element.animate({left:'+='+this.movement_distance},400, motionTo)
      this.element.animate({left:'-='+this.movement_distance},400, motionFrom)

    this.element.animate({left:'+='+this.movement_distance},400, motionTo)
    this.element.fadeOut()

  set_timeout: ->
    this.shouldShow = true
    $.doTimeout( this.display_timeout, =>
      this.show()
    )
