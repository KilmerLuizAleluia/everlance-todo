require 'rails_helper'

describe AuthenticationController, type: :controller do
  let(:email) { 'email@gmail.com' }
  let(:result) { JSON.parse(response.body) }
  let(:params) do
    {
      email: email,
      password: 'password'
    }
  end

  describe 'POST #login' do
    subject { post(:login, params: params, format: :json) }

    context 'when correct user data is sent' do
      let!(:user) { create(:user, email: email) }

      it 'should find user and sign in' do
        subject
        expect(response).to have_http_status(:success)
        expect(result['token']).not_to be_nil
        expect(result['email']).to eq(user.email)
      end
    end

    context 'when user does not exist' do
      it 'should return 401' do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(result['error']).to eq('Wrong email or password.')
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
        expect(result['error']).to eq('Wrong email or password.')
      end
    end
  end
end
