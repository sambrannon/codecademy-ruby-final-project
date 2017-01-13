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
end

class Task
  attr_reader :description
  def initialize(description)
    @description = description
  end
end

# Run code
if __FILE__ == $PROGRAM_NAME
  my_list = List.new
  puts 'You have created a new list'

  puts 'Enter a todo and press enter'
  task_description = gets.chomp
  task = Task.new(task_description)
  my_list.add(task)
  puts "You have added the task of '#{task.description}' to your list."
  puts "Here's your list now:"
  my_list.all_tasks.each do |task|
    puts "- #{task.description}"
  end
end
