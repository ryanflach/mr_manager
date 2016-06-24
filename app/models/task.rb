class Task
  attr_reader :id,
              :title,
              :description
              
  def initialize(data)
    @id          = data['id']
    @title       = data['title']
    @description = data['description']
end
