require 'bundler/setup'
Bundler.require :test

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rack/apimock'

module TestApplicationHelper
  extend self

  class TestApplication
    def call(env)
      [204, {}, ""]
    end
  end
end
