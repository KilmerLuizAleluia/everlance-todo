class CreateTaskService
  attr_reader :params

  def initialize(args)
    @params = args[:params]
  end

  def call
    task = Task.new(params)
    task.save!
    task
  end
end