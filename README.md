# Quiz App

### Proof of concept for extracting questions and answers from markdown notes using custom markdown syntax

**Current QA tag:**
~~~text
  ```q
  **Bolded question here?**
  Answer here...
  ```
~~~

**After forking:**
1. `bundle install` to install all gems and dependencies.
2. `bundle exec ruby quiz.rb` to host the app locally.
3. App should be runing at URL `localhost:4567`.
4. Input markdown to the form and submit to see extracted questions and answers.