require_relative 'test_helper'
class IdeaTest < MiniTest::Unit::TestCase

include Rack::Test::Methods

  def test_it_has_any_idea_what_an_idea_is
    idea = Idea.new
    assert_kind_of Idea, idea
  end

end
