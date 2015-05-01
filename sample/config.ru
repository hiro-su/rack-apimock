require 'pathname'
$LOAD_PATH << Pathname.new(__FILE__).dirname.join('..', 'lib').expand_path.to_s

require 'sinatra'
require 'rack/apimock'

use Rack::APIMock, apidir: File.expand_path(File.dirname(__FILE__)) + "/api"

run Sinatra::Application
