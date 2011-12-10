class this.Arrow
  constructor: (element, display_timeout, movement_distance) ->
    this.element = element
    this.display_timeout = display_timeout
    this.movement_distance = movement_distance

  set: ->
    this.position()
    this.set_timeout()

  subtract_pixels: ( position, value ) ->
    position_text = position.replace("px", "")
    return position_text - value

  cancel: ->
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

  position: ->
    x = $('#current_letter').css('left')
    y = $('#current_letter').css('top')

    this.element.css('left', this.subtract_pixels(x, 50))
    this.element.css('top', y)

  set_timeout: ->
    this.shouldShow = true
    $.doTimeout( this.display_timeout, =>
      this.show()
    )
