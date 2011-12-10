class this.Arrow
  constructor: (element) ->
    this.element = element

  position: ->
    x = $('#current_letter').css('left')
    y = $('#current_letter').css('top')

    this.element.css('left', this.subtractPixels(x, 50))
    this.element.css('top', y)

  subtractPixels: ( position, value ) ->
    position_text = position.replace("px", "")
    return position_text - value

  show: ->
    this.element.fadeIn()
    motionTo = 'easeInQuad'
    motionFrom = 'easeOutQuad'

    distance = 200

    for i in [0..3]
      this.element.animate({left:'-='+distance},400, motionFrom)
      this.element.animate({left:'+='+distance},400, motionTo)
    this.element.fadeOut()
