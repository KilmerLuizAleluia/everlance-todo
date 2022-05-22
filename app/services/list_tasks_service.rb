class ListTasksService
  attr_reader :filter, :user

  def initialize(args)
    @filter = args[:filter]
    @user = args[:user]
  end

  def call
    case filter
    when 'uncompleted_tasks'
      user.tasks.select { |task| !task.completed }
    when 'completed_tasks'
      user.tasks.select { |task| task.completed }
    else
      user.tasks
    end
  end
end