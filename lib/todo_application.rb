require_relative './todo'

class TodoApplicationError < StandardError; end

class TodoApplication
  def initialize(list_name = 'todolist')
    @list_name = list_name
    @todo_list = Todo::List.new
    load
  end

  def list
    if todo_list.empty?
      puts <<~EOT
        The list is empty. Use the add command to add items:
          todo add buy bread
      EOT
    else
      puts todo_list
    end
  end

  def add(description)
    new_item = Todo::Item.new description
    todo_list.add_todo new_item
    save_and_list
  end

  def delete(position)
    todo_list.delete_todo check_position(position)
    save_and_list
  end

  def complete(position)
    todo_list.complete_todo check_position(position)
    save_and_list
  end

  def uncomplete(position)
    todo_list.uncomplete_todo check_position(position)
    save_and_list
  end

  def clear
    todo_list.clear
    save_and_list
  end

  private

  attr_accessor :todo_list
  attr_reader :list_name

  def load
    todo_list.load! list_name
  end

  def save_and_list
    todo_list.save! list_name
    list
  end

  def check_position(p)
    position = Integer(p)
    if position < 1
      raise TodoApplicationError.new("List items start at number 1")
    end

    if position > (size = todo_list.size)
      raise TodoApplicationError.new("The list only has #{size} item#{size == 1 ? '' : 's'}")
    end

    position
  rescue ArgumentError
    raise TodoApplicationError.new("I was expecting a number, but got '#{p}' instead")
  end
end

