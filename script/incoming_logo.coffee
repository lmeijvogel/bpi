class this.IncomingLogo
  constructor: (element) ->
    this.element = element

  display: ->
    this.element.css('left', "-100px")

    this.element.animate( {
      left: '+='+ 7,
      opacity: 1.0
      }
      2000
    )
