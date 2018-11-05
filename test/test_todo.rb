require 'minitest/autorun'
require 'todo'

class TestTodo < Minitest::Test
  def setup
    @todo = Todo::Item.new "description"
  end

  def test_that_a_new_todo_is_not_complete
    refute @todo.complete?
  end

  def test_that_a_completed_todo_is_complete
    @todo.complete!
    assert @todo.complete?
  end

  def test_that_an_uncompleted_todo_is_not_complete
    @todo.complete!
    @todo.uncomplete!
    refute @todo.complete?
  end
end

class TestTodoList < Minitest::Test
  def setup
    @todo_list = Todo::List.new
    @test_todo = Todo::Item.new "item"
  end

  def test_that_a_new_todo_list_is_all_complete
    assert @todo_list.complete?
  end

  def test_that_a_new_todo_list_is_empty
    assert @todo_list.empty?
  end

  def test_that_a_list_with_a_todo_is_not_empty
    @todo_list.add_todo @test_todo
    refute @todo_list.empty?
  end

  def test_that_a_list_contains_an_added_todo
    @todo_list.add_todo @test_todo
    assert_equal 1, @todo_list.todos.length
  end

  def test_that_a_list_with_an_incomplete_todo_is_not_complete
    @todo_list.add_todo @test_todo
    @todo_list.complete_todo 1
    @todo_list.add_todo Todo::Item.new("item 2")
    refute @todo_list.complete?
  end

  def test_that_deleting_the_single_todo_leaves_an_empty_list
    @todo_list.add_todo @test_todo
    @todo_list.delete_todo 1
    assert_equal 0, @todo_list.todos.length
  end

  def test_that_completing_the_single_todo_leaves_a_complete_list
    @todo_list.add_todo @test_todo
    @todo_list.complete_todo 1
    assert @todo_list.complete?
  end

  def test_saving_and_loading_a_list
    @todo_list.add_todo @test_todo
    @todo_list.complete_todo 1
    @todo_list.save!(:test_list)
    new_list = Todo::List.new
    new_list.load!(:test_list)
    assert_equal @todo_list.to_s, new_list.to_s
  ensure
    %x(rm -f test_list.dat)
  end
end

