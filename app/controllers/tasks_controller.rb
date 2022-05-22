class TasksController < ApplicationController
  before_action :authorize

  def index
    case params[:filter]
    when 'uncompleted_tasks'
      @tasks = current_user.tasks.select { |task| !task.completed }
    when 'completed_tasks'
      @tasks = current_user.tasks.select { |task| task.completed }
    else
      @tasks = current_user.tasks
    end

    render json: @tasks, status: :ok
  end

  def show
    @task = Task.find(params[:id])
    render json: @task, status: :ok
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
    render json: { message: "Task ##{params[:id]} destroyed." }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task ##{params[:id]} not found" }, status: :not_found
  end

  private

  def task_params
    params.require(:task).permit(:title, :completed, notes: [])
  end
end
