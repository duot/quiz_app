# frozen_string_literal:true

require 'sinatra/base'
require 'tilt/erubis'
require 'redcarpet'
require_relative 'qa_parser'

class QuizService < Sinatra::Application
  configure :development do
    require 'sinatra/reloader'
    require 'pry'
  end

  configure do
    set :erb, escape_html: true
    set :root, File.expand_path('../..', __FILE__)
  end

  def load_file_content(path)
    content = File.read path
    case File.extname path # whitelist file types
    when '.md', '.markdown'
      markdown = Redcarpet::Markdown.new Redcarpet::Render::HTML
      markdown.render(content)
    end
  end

  def data_path
    settings.data_path
  end

  def join_data_path(file_name)
    File.join(settings.data_path, File.basename(file_name))
  end

  get '/' do
    pattern = join_data_path '*.md'
    @files = Dir.glob(pattern).map(&File.method(:basename))
    erb :index
  end

  get '/:file_name' do
    text = File.read join_data_path(params[:file_name])
    @questions = QAParser.scan(text)
    erb :quiz
  end

  get '/raw/:file_name' do
    file_path = join_data_path(params[:file_name])
    if File.exist? file_path
      load_file_content file_path
    end
  end
end
