require 'erb'

module Rack
  class APIMock
    def initialize(app, basedir: 'api')
      @app = app
      @basedir = basedir
    end

    def call(env)
      @status, @header = 200, {}
      file_path = get_template_path(env)

      # Missing Template File
      return @app.call(env) unless file_path

      response = ERB.new(::File.open(file_path, &:read), nil, '<>').result(binding)
      [@status, @header, [response]]
    end

    private

    def get_template_path(env)
      request_path = env['REQUEST_PATH'].downcase
      request_path = "index" if request_path == "/"
      request_method = env['REQUEST_METHOD'].downcase
      template = ::File.join @basedir, "#{request_path}_#{request_method}*"
      return Dir.glob(template).first
    end
  end
end
