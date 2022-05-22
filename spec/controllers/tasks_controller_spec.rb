require 'rails_helper'

describe TasksController, type: :controller do
  let(:result) { JSON.parse(response.body) }

  describe 'POST #create' do
    subject { post(:create, params: params, format: :json) }

    let(:user) { create(:user) }
    let(:params) do
      {
        task: {
          title: 'Task Title',
          completed: false,
          notes: ['first note', 'second note']
        }
      }
    end

    context 'when user is logged in' do
      it 'should create task' do
        session[:user_id] = user.id
        expect { subject }.to change { Task.count } .by(1)

        task = Task.last
        expect(response).to have_http_status(:success)
        expect(result['id']).to eq(task.id)

        expect(task.title).to eq('Task Title')
        expect(task.completed).to eq(false)
        expect(task.notes).to eq(['first note', 'second note'])

        expect(user.reload.tasks.size).to eq(1)
      end

      context 'adding without notes' do
        let(:params) do
          {
            task: {
              title: 'Task Great Title',
              completed: true,
            }
          }
        end

        it 'should create task' do
          session[:user_id] = user.id
          subject

          task = Task.last
          expect(task.title).to eq('Task Great Title')
          expect(task.completed).to eq(true)
          expect(task.notes).to eq([])
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    subject { put(:update, params: params, format: :json) }

    let(:task) { create(:task) }
    let(:user) { create(:user) }
    let(:params) do
      {
        id: task.id,
        task: {
          title: 'New Task Title',
          completed: true,
          notes: ['first note', 'second note', 'third note']
        }
      }
    end

    context 'when user is logged in' do
      it 'should update existing task' do
        session[:user_id] = user.id
        subject

        expect(response).to have_http_status(:success)
        expect(result['id']).to eq(task.id)

        expect(task.reload.title).to eq('New Task Title')
        expect(task.completed).to eq(true)
        expect(task.notes).to eq(['first note', 'second note', 'third note'])
      end
    end

    context 'when user is not logged in' do
      it 'should return unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #delete' do
    subject { delete(:destroy, { id: task_id }) }
    let!(:task) { create(:task) }
    let(:task_id) { task.id }

    context 'when user is logged in' do
      let(:user) { create(:user) }

      context 'trying to delete existing task' do
        it 'shoudl delete' do
          session[:user_id] = user.id
          expect { subject }.to change { Task.count } .by(-1)
          expect(response).to have_http_status(:ok)
          expect(result['message']).to eq("Task ##{task_id} destroyed.")
        end
      end

      context 'trying to delete unexisting task' do
        let!(:task_id) { 50000 }

        it 'shoudl return not_found' do
          session[:user_id] = user.id
          expect { subject }.to change { Task.count } .by(0)
          expect(response).to have_http_status(:not_found)
          expect(result['error']).to eq("Task ##{task_id} not found")
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #index' do
    subject { get(:index, params: params, format: :json) }
    let(:params) { {} }
    let(:user) { create(:user) }

    context 'when user is not logged in' do
      context 'no filter params' do
        context 'when there is no tasks' do
          it 'should return unauthorized' do
            session[:user_id] = user.id
            subject
            expect(response).to have_http_status(:ok)
            expect(result).to eq([])
          end
        end

        context 'when there is multiple tasks' do
          before do
            10.times do
              Task.create(user_id: user.id)
            end
          end

          it 'should return all taks' do
            session[:user_id] = user.id
            subject
            expect(response).to have_http_status(:ok)
            expect(result.size).to eq(10)
          end
        end
      end

      context 'with uncompleted_tasks params' do
        let(:params) { { filter: 'uncompleted_tasks' } }
        before do
          7.times do
            Task.create(user_id: user.id, completed: true)
          end
          5.times do
            Task.create(user_id: user.id, completed: false)
          end
        end

        it 'should return all taks' do
          session[:user_id] = user.id
          subject
          expect(response).to have_http_status(:ok)
          expect(result.size).to eq(5)
        end
      end

      context 'with completed_tasks params' do
        let(:params) { { filter: 'completed_tasks' } }
        before do
          9.times do
            Task.create(user_id: user.id, completed: true)
          end
          3.times do
            Task.create(user_id: user.id, completed: false)
          end
        end

        it 'should return all taks' do
          session[:user_id] = user.id
          subject
          expect(response).to have_http_status(:ok)
          expect(result.size).to eq(9)
        end
      end

      context 'when there is tasks from multiple users' do
        before do
          5.times do
            Task.create(user_id: user.id, completed: true)
          end
        end
        let(:user2) { create(:user) }

        it 'should not be able to see othter user tasks' do
          session[:user_id] = user2.id
          subject
          expect(response).to have_http_status(:ok)
          expect(result.size).to eq(0)
        end
      end
    end

    context 'when user is not logged in' do
      it 'should return unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
