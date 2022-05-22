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

    let!(:task) { create(:task) }
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

  describe '#delete' do
    context 'when user is logged in' do

    end

    context 'when user is not logged in' do

    end
  end
end
