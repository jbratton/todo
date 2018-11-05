require 'pstore'

module Todo
  class Item
    attr_accessor :description
  
    def initialize(description = '', complete = false)
      @description = description
      @complete = complete
    end
  
    def complete!; self.complete = true; end
  
    def uncomplete!; self.complete = false; end
  
    def complete?; complete; end
  
    def to_s
      "#@description#{complete? ? ' ✔︎' : ''}"
    end

    private
    attr_accessor :complete
  end
  
  class List
    def initialize(items = [])
      @items = items
    end
  
    def todos; items.dup; end

    def size; todos.count; end

    def add_todo(item)
      items << item 
    end
  
    def complete_todo(position)
      items[position - 1].complete!
    end
  
    def uncomplete_todo(position)
      items[position - 1].uncomplete!
    end
  
    def delete_todo(position)
      items.delete_at position - 1
    end

    def clear
      items.clear
    end

    def complete?
      items.all? &:complete?
    end

    def empty?; items.empty?; end

    def save!(list_name = 'todolist')
      store = PStore.new "#{list_name}.dat"
      store.transaction do
        store[list_name] = items
      end
    end

    def load!(list_name = 'todolist')
      store = PStore.new "#{list_name}.dat"
      store.transaction(true) do
        self.items = store.fetch list_name, []
      end
    end
  
    def to_s
      items.map.with_index {|t, i| "#{i + 1}: #{t}"}.join "\n"
    end
    
    private
    attr_accessor :items
  end
end

