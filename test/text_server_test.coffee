test('if_empty_string_is_undefined', ->
  subject = new TextServer("")

  equal(subject.current_letter(), undefined, "Current letter is undefined")
  equal(subject.next_letter(), undefined, "Next letter is undefined")
  ok(!subject.has_more_letters(), "Subject does not have more letters")
)

test('if_one_character', ->
  subject = new TextServer("A")

  equal(subject.current_letter(), "A", "Current letter is 'A'")
  equal(subject.next_letter(), undefined, "Next letter is undefined")
  ok(!subject.has_more_letters(), "Subject does not have more letters")
)

test('if_two_characters', ->
  subject = new TextServer("AB")
  equal(subject.current_letter(), "A", "Current letter is 'A'")
  ok(subject.has_more_letters(), "Subject has more letters")
  equal(subject.next_letter(), "B", "Next letter is 'B'")
  equal(subject.current_letter(), "B", "Current letter is 'B'")
  ok(!subject.has_more_letters(), "Subject does not have more letters")
)


