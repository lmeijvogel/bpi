class this.Arrow
  constructor: (element) ->
    this.element = element

  position: ->
    x = $('#current_letter').css('left')
    y = $('#current_letter').css('top')

    this.element.css('left', this.subtract_pixels(x, 50))
    this.element.css('top', y)

  subtract_pixels: ( position, value ) ->
    position_text = position.replace("px", "")
    return position_text - value

  set_timeout: ->
    this.shouldShow = true
    $.doTimeout( 2000, =>
      this.show()
    )

  cancel_timeout: ->
    this.shouldShow = false

  show: ->
    unless this.shouldShow
      return

    motionTo = 'easeInQuad'
    motionFrom = 'easeOutQuad'

    distance = 200

    # "silently" move arrow back so it can point forward again.
    this.element.animate({left:'-='+distance},0, motionFrom)
    this.element.fadeIn()
    for i in [0..3]
      this.element.animate({left:'+='+distance},400, motionTo)
      this.element.animate({left:'-='+distance},400, motionFrom)

    this.element.animate({left:'+='+distance},400, motionTo)
    this.element.fadeOut()
