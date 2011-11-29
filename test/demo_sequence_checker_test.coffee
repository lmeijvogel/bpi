module "DemoSequenceChecker.letter_pressed",
  setup: -> this.subject = new DemoSequenceChecker('demo')

test('if no keys are pressed', ->
  same(this.subject.expected_letter(), 'd', "Expected letter is 'd'")
  ok(!this.subject.complete(), "Sequence is not yet complete")
)

test('after the first key is pressed', ->
  this.subject.letter_pressed('d')
  same(this.subject.expected_letter(), 'e', "Expected letter is 'e'")
  ok(!this.subject.complete(), "Sequence is not yet complete")
)

test('after the second key is pressed', ->
  this.subject.letter_pressed('d')
  this.subject.letter_pressed('e')
  same(this.subject.expected_letter(), 'm', "Expected letter is 'm'")
  ok(!this.subject.complete(), "Sequence is not yet complete")
)

test('when a wrong letter is pressed at the start of the sequence', ->
  this.subject.letter_pressed('a')
  same(this.subject.expected_letter(), 'd', "Expected letter is 'd'")
  ok(!this.subject.complete(), "Sequence is not yet complete")
)

test('when a wrong letter is pressed during the sequence', ->
  this.subject.letter_pressed('d')
  this.subject.letter_pressed('e')
  this.subject.letter_pressed('m')
  this.subject.letter_pressed('m')

  same(this.subject.expected_letter(), 'd', "Expected letter is 'd'")
  ok(!this.subject.complete(), "Sequence is not yet complete")
)

test('when the sequence is completed', ->
  subject = new DemoSequenceChecker("a")
  subject.letter_pressed('a')
  ok(subject.complete(), "Sequence is complete")
)
