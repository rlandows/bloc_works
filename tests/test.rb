# require_relative '../lib/bloc_works.rb'
require "bloc_works"
require 'rack/test'
require 'test/unit'

$LOAD_PATH << File.join(File.dirname(__FILE__), "controllers")



class CallTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    BlocWorks::Application.new
  end

  def test_response_is_ok
    get "/"

    assert last_response.ok?
    assert_equal last_response.body, "Hello Blocheads"
  end

  def test_favicon

    get "/favicon.ico"

    assert_equal last_response.body, ""
    assert_equal last_response.status, 404
  end

  def random_test

    get "/blah/woo"

    assert_equal last_response.body, "Gotcha"
  end

end
