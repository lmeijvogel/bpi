class this.Timer extends CenteredElement
  constructor: (text_element, text, screen_dimensions) ->
    super( text_element, screen_dimensions, [0, 300] )
    this.text_element = text_element
    this.text = text

    this.time_element = text_element.find(".time")
    this.wpm_element = text_element.find(".wpm")

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

    total_minutes = (seconds + 60*minutes) / 60
    total_words = this.text.length / 6
    wpm = Math.round(total_words / total_minutes)

    seconds = "0"+seconds if seconds < 10

    this.time_element.text(minutes + ":" + seconds)
    this.wpm_element.text(wpm)

    this.position()
    this.text_element.fadeIn()
