class DeleteTaskService
  attr_reader :id

  def initialize(args)
    @id = args[:id]
  end

  def call
    task = Task.find(id)
    task.destroy

    { message: "Task ##{id} destroyed." }
  end
end