require 'minitest/autorun'
require 'rack/test'

require_relative '../quiz'

class QuizTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_simple_qa
    md = <<-SAMPLE
```q
**This is a question**
This is an answer
```
SAMPLE

    post "/submit", markdown: md
    assert_equal last_response.status, 200
    assert_includes last_response.body, "<strong>This is a question</strong>"
    assert_includes last_response.body, "<p>This is an answer</p>"
  end

  def test_qa_with_ordered_list
    md = <<-SAMPLE
# These are my notes

notes notes notes
They're **MY** notes! Hands off!

```q
**This is a question**
Answering...

1. Part 1
2. Part 2
3. Part 3
```
SAMPLE

    post "/submit", markdown: md
    assert_equal last_response.status, 200
    assert_includes last_response.body, "<strong>This is a question</strong>"
    assert_includes last_response.body, "<ol>\n<li>Part 1</li>\n<li>Part 2</li>\n<li>Part 3</li>\n</ol>"
  end

  def test_multiple_questions
    md = <<-SAMPLE
# These are my notes

notes notes notes
They're **MY** notes! Hands off!

```q
**This is a question**
This is an answer
```
```q
**This is another question**
This is another answer
```
SAMPLE

    post "/submit", markdown: md
    assert_equal last_response.status, 200
    assert_includes last_response.body, "<strong>This is a question</strong></p><p>This is an answer</p>"
    assert_includes last_response.body, "<strong>This is another question</strong></p><p>This is another answer</p>"
  end

  def test_non_qa_text_omitted
    md = <<-SAMPLE
# These are my notes

notes notes notes
They're **MY** notes! Hands off!

```q
**This is a question**
This is my answer.
```

And these are other notes.
- You can use these ones.
  SAMPLE
    post "/submit", markdown: md
    assert_equal last_response.status, 200
    refute_includes last_response.body, "You can use these ones."
  end
end