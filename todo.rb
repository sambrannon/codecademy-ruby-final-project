# Modules
module Menu
  def menu
    "What would you like to do?
    [1] Add
    [2] Show
    [3] Update
    [4] Delete
    [5] Write to file
    [6] Read from file
    [7] Toggle Status
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
    all_tasks.map.with_index { |task, i| "#{i.next}) #{task}" }
  end

  def update(task_number, task)
    all_tasks[task_number.to_i - 1] = task
  end

  def delete(task_number)
    all_tasks.delete_at(task_number.to_i - 1)
  end

  def write_to_file(filename)
    IO.write(filename, @all_tasks.map(&:to_machine).join("\n"))
  end

  def read_from_file(filename)
    IO.readlines(filename).each do |line|
      status, *description = line.split(' : ')
      status = status.include?('X')
      add(Task.new(description.join(' : ').strip, status))
    end
  end

  def toggle(task_number)
    all_tasks[task_number.to_i - 1].toggle_status
  end
end

class Task
  attr_reader :description
  attr_accessor :completed_status

  def initialize(description, completed_status = false)
    @description = description
    @completed_status = completed_status
  end

  def to_s
    description
  end

  def completed?
    completed_status
  end

  def to_machine
    "#{represent_status} : #{description}"
  end

  def toggle_status
    @completed_status = !completed?
  end

  private

  def represent_status
    "#{completed? ? '[X]' : '[ ]'}"
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
      # add
      task = Task.new(prompt("What task would you like to accomplish?"))
      my_list.add(task)
    when '2'
      # show
      my_list.show.each do |task|
        puts task
      end
    when '3'
      #update
      task_to_update = prompt("Which item to update?")
      updated_task_description = Task.new(prompt("Updated task description?"))
      my_list.update(task_to_update, updated_task_description)
    when '4'
      # delete
      my_list.delete(prompt("Which item would you like to delete?"))
    when '5'
      # write
      my_list.write_to_file(prompt("Name of file?"))
    when '6'
      # read
      begin
        my_list.read_from_file(prompt("Name of file?"))
      rescue Errno::ENOENT
        puts 'File name not found, please verify your file name and path.'
      end
    when '7'
      # toggle status
      puts my_list.show
      my_list.toggle(prompt("Which item would you like to toggle?"))
    else
      puts 'Sorry, I did not understand'
    end
  end

  puts 'Thanks for using the menu system!'
end
