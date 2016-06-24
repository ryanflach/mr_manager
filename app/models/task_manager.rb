require 'yaml/store'
require_relative 'task'

class TaskManager
  attr_reader :database

  def initialize(database)
    @database = database
  end

  def create(task)
    database.transaction do
      database['tasks'] ||= []
      database['total'] ||= 0
      database['total'] += 1
      database['tasks'] << { "id" => database['total'], "title" => task[:title], "description" => task[:description] }
    end
  end

  def raw_tasks
    database.transaction do
      database['total'] = 0 if database['tasks'].empty?
      database['tasks'][0]['id'] = 1 if database['tasks'].count == 1
      database['tasks'] || []
    end
  end

  def all
    raw_tasks.map { |data| Task.new(data) }
  end

  def raw_task(id)
    raw_tasks.find { |task| task['id'] == id }
  end

  def find(id)
    Task.new(raw_task(id))
  end

  def remove(id)
    database.transaction do
      database['tasks'].delete_at(id - 1)
      database['total'] -= 1
      database['tasks'].each do |task|
        task['id'] -= 1 if task['id'] > id
      end
    end
  end

end
