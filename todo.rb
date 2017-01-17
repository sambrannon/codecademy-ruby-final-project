# Modules
module Menu
  def menu
    "What would you like to do?
    [1] Add a todo
    [2] Show all todos
    [3] Write to a fale
    [4] Read from file
    [Q] Quit"
  end

  def show
    menu
  end
end

module Promptable
  def prompt(message = 'What would you like to do?', symbol = ':> ')
    puts message
    print symbol
    gets.chomp
  end
end

# Classes
class List
  attr_reader :all_tasks

  def initialize
    @all_tasks = []
  end

  def add(task)
    all_tasks << task
  end

  def show
    all_tasks
  end

  def write_to_file(filename)
    IO.write(filename, @all_tasks.map(&:to_s).join("\n"))
  end
end

class Task
  attr_reader :description
  def initialize(description)
    @description = description
  end

  def to_s
    description
  end
end

# Run code
if __FILE__ == $PROGRAM_NAME
  include Menu
  include Promptable

  my_list = List.new

  until ['q'].include?(user_input = prompt(show).downcase)
    case user_input
    when '1'
      task = Task.new(prompt("What task would you like to accomplish?"))
      my_list.add(task)
    when '2'
      my_list.show.each do |task|
        puts "- #{task.description}"
      end
    when '3'
      my_list.write_to_file(prompt("Name of file?"))
    else
      puts 'Sorry, I did not understand'
    end
  end

  puts 'Thanks for using the menu system!'
end
