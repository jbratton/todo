require 'minitest/autorun'
require 'todo_application'

class TestTodoApplication < Minitest::Test
  def setup
    @app = TodoApplication.new(:test_list)
  end

  def teardown
    %x{rm -f test_todolist.dat}
  end

  def test_that_non_numeric_position_raises
    assert_raises TodoApplicationError do
      @app.complete "three"
    end
  end

  def test_that_non_existent_position_raises
    assert_raises TodoApplicationError do
      @app.uncomplete "7"
    end
  end

  def test_that_negative_position_raises
    assert_raises TodoApplicationError do
      @app.delete "-1"
    end
  end
end

