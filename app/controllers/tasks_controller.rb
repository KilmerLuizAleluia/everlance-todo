class TasksController < ApplicationController
  before_action :authorize

  def index
    @tasks = Task.all

    # this looks weird
    json = []
    @tasks.each do |task|
      json << {"title": task.title, "completed": task.completed}
    end

    render json: json
  end

  def uncompleted_tasks
    @tasks = Task.all.where(completed: false)

    # weird
    json = []
    @tasks.each do |task|
      json << {"title": task.title, "completed": task.completed}
    end

    render json: json
  end

  def completed_tasks
    @tasks = Task.all.where(completed: true)

    # weird
    json = []
    @tasks.each do |task|
      json << {"title": task.title, "completed": task.completed}
    end

    render json: json
  end

  def show
    @task = Task.find(params[:id])
    render json: {"title": @task.title, "completed": @task.completed}
  end

  def create
    @task = Task.new(task_params.merge(user: current_user))

    if @task.save
      render json: @task, status: :ok
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
  end

  private

  def task_params
    params.require(:task).permit(:title, :completed, notes: [])
  end
end
