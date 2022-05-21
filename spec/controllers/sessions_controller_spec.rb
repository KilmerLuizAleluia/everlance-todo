require 'rails_helper'

describe SessionsController, type: :controller do
  let(:email) { 'email@gmail.com' }
  let(:result) { JSON.parse(response.body) }
  let(:params) do
    {
      email: email,
      password: 'password'
    }
  end

  describe 'POST #create, sign in' do
    subject { post(:create, params: params, format: :json) }

    context 'when correct user data is sent' do
      let!(:user) { create(:user, email: email) }

      it 'should find user and sign in' do
        subject
        byebug
        expect(response).to have_http_status(:success)
        expect(result['message']).to eq('User logged in.')
        expect(result['user_id']).to eq(user.id)
        expect(session['user_id']).to eq(user.id)
      end

      it 'should return current user' do
        subject
        expect(controller.current_user).to eq(user)
      end

      it 'should be logged in' do
        subject
        expect(controller.logged_in?).to be_truthy
      end
    end

    context 'when user does not exist' do
      it 'should return 401' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(result['message']).to eq('Wrong email or password.')
        expect(session['user_id']).to be_nil
      end
    end

    context 'when wrong user data is sent' do
      let!(:user) { create(:user, email: email) }
      let(:params) do
        {
          email: email,
          password: 'wrong password'
        }
      end

      it 'should return 401' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(result['message']).to eq('Wrong email or password.')
        expect(session['user_id']).to be_nil
      end
    end
  end

  describe 'DELETE #destroy, sign out' do
    context 'when there is a logged user' do
      subject { delete(:destroy) }
      let!(:user) { create(:user, email: email) }

      it 'should clean session' do
        post(:create, params: params, format: :json)
        expect(controller.logged_in?).to be_truthy

        subject

        expect(controller.logged_in?).to be_falsey
        expect(response).to have_http_status(:ok)
        expect(result['message']).to eq('User logged out.')
      end
    end

    context 'when there is not a logged user' do
      subject { delete(:destroy) }

      it 'should clean session' do
        expect(controller.logged_in?).to be_falsey

        subject

        expect(controller.logged_in?).to be_falsey
        expect(response).to have_http_status(:not_modified)
        expect(result['message']).to eq('No user is logged in.')
      end
    end
  end
end
