# frozen_string_literal: true

require_relative 'quiz_service'

# Class to handle all the cli interaction.
class CLI
  def initialize(args)
    @path = args.first
    abort 'Please provide a file path.' unless @path
  end

  def run
    QuizService.set :data_path, File.expand_path(@path)
    QuizService.run!
  end
end
