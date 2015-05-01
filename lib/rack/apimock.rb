require 'erb'

module Rack
  class APIMock
    def initialize(app, apidir: 'api')
      @app = app
      @apidir = apidir
    end

    def call(env)
      @status, @headers = 200, {}
      file_path = get_template_path(env)

      # Missing Template File
      return @app.call(env) unless file_path

      response = ERB.new(::File.open(file_path, &:read), nil, '<>').result(binding)

      unless env['QUERY_STRING'].empty?
        query_string = Rack::Utils.parse_nested_query(env['QUERY_STRING'])

        case env["CONTENT_TYPE"]
        when /application\/json/i
          require 'json'
          data = JSON.parse(response)
          response = query_string.each_with_object({}) {|(key, _), new_hash|
            new_hash.merge!(key => data[key])
          }.to_json
        end
      end

      [@status, @headers, [response]]
    end

    private

    def get_template_path(env)
      request_path = env['REQUEST_PATH']
      request_path = "index" if request_path == "/"
      request_method = env['REQUEST_METHOD'].downcase
      template = ::File.join @apidir, "#{request_path.downcase}_#{request_method}*"
      content_type = unless env['CONTENT_TYPE'].nil? || env['CONTENT_TYPE'].empty?
                       env['CONTENT_TYPE']
                     end || 'application/json'
      file_type = content_type.split('/').last
      return Dir.glob(template).select{|f| f =~ /#{file_type}/i }.first
    end
  end
end
