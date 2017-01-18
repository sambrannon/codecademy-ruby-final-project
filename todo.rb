# Modules
module Menu
  def menu
    "What would you like to do?
    [1] Add
    [2] Show
    [3] Delete
    [4] Write to file
    [5] Read from file
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

  def delete(task_number)
    all_tasks.delete_at(task_number.to_i - 1)
  end

  def write_to_file(filename)
    IO.write(filename, @all_tasks.map(&:to_s).join("\n"))
  end

  def read_from_file(filename)
    IO.readlines(filename).each do |line|
      add(Task.new(line.chomp))
    end
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
      # add
      task = Task.new(prompt("What task would you like to accomplish?"))
      my_list.add(task)
    when '2'
      # show
      my_list.show.each do |task|
        puts task
      end
    when '3'
      # delete
      my_list.delete(prompt("Which item would you like to delete?"))
    when '4'
      # write
      my_list.write_to_file(prompt("Name of file?"))
    when '5'
      # read
      begin
        my_list.read_from_file(prompt("Name of file?"))
      rescue Errno::ENOENT
        puts 'File name not found, please verify your file name and path.'
      end
    else
      puts 'Sorry, I did not understand'
    end
  end

  puts 'Thanks for using the menu system!'
end
