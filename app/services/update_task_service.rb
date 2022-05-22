class UpdateTaskService
  attr_reader :id, :params

  def initialize(args)
    @params = args[:params]
    @id = args[:id]
  end

  def call
    task = Task.find(id)
    task.update!(params)

    task
  end
end

