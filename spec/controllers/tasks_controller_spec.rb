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
end
