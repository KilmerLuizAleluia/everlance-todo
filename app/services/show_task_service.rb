class ShowTaskService
  attr_reader :id

  def initialize(args)
    @id = args[:id]
  end

  def call
    Task.find(id)
  end
end