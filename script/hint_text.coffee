class this.HintText extends CenteredElement
  constructor: (element, screen_size, display_timeout) ->
    super(element, screen_size, [0,100])

    this.display_timeout = display_timeout

  set: ->
    this.position_invisible()
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

  set_timeout: ->
    this.shouldShow = true

    $.doTimeout( this.display_timeout, =>
      this.show()
    )

