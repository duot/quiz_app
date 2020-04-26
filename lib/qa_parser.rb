# frozen_string_literal: true

# Usage in markdown:
#   To mark a question paragraph, start with '?' followed by a space,
#   followed by a normal paragraph.
#
#   To mark an answer paragraph, start with '.', followd by a space,
#   followed by a normal paragraph.
#
class QAParser
  QUESTION_TAG = /\?/
  ANSWER_TAG = /\.|\.\.|a\.|Answer:/

  SINGLE_SPACE = /\s{1}/
  OPTIONAL_SPACES = /#{SINGLE_SPACE}*/
  EMPTY_LINE = /^#{OPTIONAL_SPACES}*$/
  PARTIAL_LINE = /.+$\n/
  LINE = /^.+$\n/
  LINES = /#{LINE}*/
  PARAGRAPH = /#{PARTIAL_LINE}#{LINES}#{EMPTY_LINE}/

  QUESTION_MARKER = /^#{OPTIONAL_SPACES}#{QUESTION_TAG}#{SINGLE_SPACE}#{OPTIONAL_SPACES}/
  ANSWER_MARKER = /^#{OPTIONAL_SPACES}#{ANSWER_TAG}#{SINGLE_SPACE}#{OPTIONAL_SPACES}/

  QUESTION_PARAGRAPH = /#{QUESTION_MARKER}#{OPTIONAL_SPACES}(#{PARAGRAPH})/
  ANSWER_PARAGRAPH = /#{ANSWER_MARKER}#{OPTIONAL_SPACES}(#{PARAGRAPH})/

  QA = /#{QUESTION_PARAGRAPH}#{ANSWER_PARAGRAPH}?/

  def self.scan(text)
    text.scan(QA)
  end
end

if __FILE__ == $PROGRAM_NAME
  md = <<~MARKDOWN
    # Heading

    This is a normal markdown with custom paragraphs.

    ? Question sentence?

    . Answer paragraph

    Another normal paragraph.

    ? Question that extends
      in the next line

    a. A b c.

    ? Question that has no answer.

    ? Question **with** emphasis

    .. And a `..` answer tag.

    ***
  MARKDOWN

  puts md
  puts QAParser.scan(md).inspect
end
