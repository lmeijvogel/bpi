class this.TypedText
  constructor: (element, text) ->
    this.element = element
    this.text = text

    this.current_letter = -1

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
