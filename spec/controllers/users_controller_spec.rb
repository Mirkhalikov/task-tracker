require 'rails_helper'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { username: 'new_username', password: 'password', password_confirmation: 'password' } }
  let(:invalid_attributes) { { username: '', password: 'password', password_confirmation: 'password' } }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @users' do
      create_list(:user, 3)
      get :index
      expect(assigns(:users).count).to eq(4)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it 'assigns @user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns @user as a new User' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it 'redirects to the tasks path' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(tasks_path)
      end

      it 'sets a success notice' do
        post :create, params: { user: valid_attributes }
        expect(flash[:notice]).to match(/Регистрация прошла успешно/)
      end
    end

    context 'with invalid params' do
      it 'does not create a new User' do
        expect {
          post :create, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it 'redirects to the signup path' do
        post :create, params: { user: invalid_attributes }
        expect(response).to redirect_to(signup_path)
      end

      it 'sets an error notice' do
        post :create, params: { user: invalid_attributes }
        expect(flash[:notice]).to match(/Что-то пошло не так/)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a successful response' do
      get :edit, params: { id: user.id }
      expect(response).to be_successful
    end

    it 'assigns @user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    context 'when accessing another user' do
      let(:another_user) { create(:user) }

      before do
        session[:user_id] = another_user.id
      end

      it 'redirects with an alert' do
        get :edit, params: { id: user.id }
        expect(flash[:alert]).to match(/Недостаточно прав для действия/)
        expect(response).to redirect_to(users_path)
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid params' do
      it 'updates the requested user' do
        patch :update, params: { id: user.id, user: valid_attributes }
        user.reload
        expect(user.username).to eq('new_username')
      end

      it 'redirects to the users path' do
        patch :update, params: { id: user.id, user: valid_attributes }
        expect(response).to redirect_to(users_path)
      end

      it 'sets a success notice' do
        patch :update, params: { id: user.id, user: valid_attributes }
        expect(flash[:notice]).to match(/Профиль обновлён/)
      end
    end

    context 'with invalid params' do
      it 'does not update the user' do
        patch :update, params: { id: user.id, user: invalid_attributes }
        user.reload
        expect(user.username).not_to eq('')
      end

      it 'redirects back to the edit user path' do
        patch :update, params: { id: user.id, user: invalid_attributes }
        expect(response).to redirect_to(edit_user_path(user))
      end

      it 'sets an alert notice' do
        patch :update, params: { id: user.id, user: invalid_attributes }
        expect(flash[:alert]).to match(/Что-то пошло не так/)
      end
    end
  end
end
