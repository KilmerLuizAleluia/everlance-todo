class TasksController < ApplicationController
  before_action :authorize

  def index
    tasks = ::ListTasksService.new(filter: params[:filter], user: @current_user).call
    render json: tasks, status: :ok
  end

  def show
    render json: ::ShowTaskService.new(id: params[:id]).call, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task ##{params[:id]} not found" }, status: :not_found
  end

  def create
    new_task = ::CreateTaskService.new(params: task_params.merge(user: @current_user)).call
    render json: new_task, status: :created
  rescue StandardError => error
    render json: { errors: error.message }, status: :unprocessable_entity
  end

  def update
    task = ::UpdateTaskService.new(params: task_params, id: params[:id]).call
    render json: task, status: :ok
  rescue StandardError => error
    render json: { errors: error.message }, status: :unprocessable_entity
  end

  def destroy
    render json: ::DeleteTaskService.new(id: params[:id]).call, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task ##{params[:id]} not found" }, status: :not_found
  end

  private

  def task_params
    params.require(:task).permit(:title, :completed, notes: [])
  end
end
