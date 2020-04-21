# TBD:
#   Add the ability to parse alternative formatting for bold, etc.
#   ~~~ is an alternative to ``` for code blocks.
#   Find workaround for lists not formatting properly without an empty line in between non-list and list text.

require 'redcarpet'

Q_BLOCK_OPEN_TAG = '```q'
Q_BLOCK_CLOSE_TAG = '```'
QUESTION_TAG = '\*\*' # Note the single quotes are important. Otherwise, after interpolating into the regex, the \'s disappear and the * isn't escaped in the regex.
Q_AND_A_MATCHER = /#{Q_BLOCK_OPEN_TAG}\s*(#{QUESTION_TAG}.+?#{QUESTION_TAG})\s*(.+?)\s*#{Q_BLOCK_CLOSE_TAG}/m

def parse_for_q_a(md_text)
  html_converter = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  questions_answers_array = md_text.scan(Q_AND_A_MATCHER)

  questions_answers_array.map do |question, answer|
    "#{html_converter.render(question).chomp}#{html_converter.render(answer).chomp}"
    # I added String#chomp because #render was putting a newline at the end of each chunk of html.
  end
end

# Problems:
  # If several questions are printed in a row without answers, the first question is captured and all subsequent questions are ignored until the next answer is found and paired with first question.
  # For some reason lists are getting included in the preceding <p> tag element and aren't getting converted to html (with <ul>, <ol> or <li> tags) unless an empty line is place between the previous non-list text and the start of the list.