class this.Timer extends CenteredElement
  constructor: (text_element, screen_dimensions) ->
    super( text_element, screen_dimensions, [0, 300] )
    this.text_element = text_element

    this.time_element = text_element.find(".time")

    this.running = false

  start_if_necessary: () ->
    unless this.running
      this.running = true
      this.start_time = new Date()

  done: () ->
    this.running = false

    elapsed_time = new Date()
    elapsed_time.setTime( new Date() - this.start_time )
    minutes = elapsed_time.getMinutes()
    seconds = elapsed_time.getSeconds()

    seconds = "0"+seconds if seconds < 10

    this.time_element.text(minutes + ":" + seconds)

    this.position()
    this.text_element.fadeIn()
