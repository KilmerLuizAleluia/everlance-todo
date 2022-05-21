require 'rails_helper'

describe UsersController, type: :controller do
  let(:result) { JSON.parse(response.body) }

  describe 'POST #create' do
    subject { post(:create, params: params, format: :json) }

    context 'with correct params' do
      let(:params) do
        {
          email: 'email@gmail.com',
          password: 'password'
        }
      end

      it 'should create user' do
        expect { subject }.to change { User.count } .by(1)
        expect(response).to have_http_status(:success)
        expect(session['user_id']).to eq(result['id'])
        expect(result['email']).to eq(params[:email])
      end

      it 'should login' do
        subject
        expect(controller.logged_in?).to be_truthy
        expect(controller.current_user).to eq(User.find(result['id']))
      end
    end

    context 'with incorrect params' do
      context 'with wrong email' do
        let(:params) do
          {
            email: 'wrong',
            password: 'password'
          }
        end

        it 'should not create User' do
          expect { subject }.to change { User.count } .by(0)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(result).to have_key('errors')
          expect(result['errors']).to have_key('email')
          expect(result['errors']['email'].first).to eq('is invalid')
        end
      end

      context 'with wrong password' do
        let(:params) do
          {
            email: 'email@gmail',
            password: 'pass'
          }
        end

        it 'should not create User' do
          expect { subject }.to change { User.count } .by(0)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(result).to have_key('errors')
          expect(result['errors']).to have_key('password')
          expect(result['errors']['password'].first).to eq('is too short (minimum is 6 characters)')
        end
      end
    end
  end
end
