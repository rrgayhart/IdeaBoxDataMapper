require_relative 'test_helper'

class EngineTest < MiniTest::Test

  include Rack::Test::Methods

  def app
    IdeaBoxApp
  end

  def test_hello_world
    get '/'
    assert last_response.ok?
    assert last_response.body =~ /Mighty/
  end
end
