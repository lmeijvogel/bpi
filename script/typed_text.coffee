class this.TypedText extends CenteredElement
  constructor: (element, screen_dimensions, text) ->
    super(element, screen_dimensions, [0, 200])

    this.element = element
    this.screen_height = screen_dimensions[1]

    this.current_letter = -1

    this.set_contents(text)

  set_contents: (text) ->
    element_contents = $('<div>')

    for char, index in text.split ''
      if char == "\n"
        display_char = "<br />"
      else
        display_char = char

      element_contents.append("<span id='letter_#{index}' style='display: none;'>#{display_char}</span>")

    this.element.append(element_contents)

  next_letter: ->
    this.current_letter++

    letter = $("#letter_#{this.current_letter}")
    letter.show()
