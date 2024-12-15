require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let!(:user) { create(:user, password: 'password') }
  let!(:task) { create(:task, user: user) }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'assigns @tasks and @users' do
      get :index
      expect(assigns(:tasks)).to match_array(Task.all)
      expect(assigns(:users)).to eq(User.all)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested task to @task' do
      get :show, params: { id: task.id }
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'GET #new' do
    it 'assigns a new task to @task' do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new task' do
        expect {
          post :create, params: { task: attributes_for(:task) }
        }.to change(Task, :count).by(1)
      end

      it 'redirects to the tasks path' do
        post :create, params: { task: attributes_for(:task) }
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to eq('Задача была создана.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new task' do
        expect {
          post :create, params: { task: attributes_for(:task, title: nil) }
        }.not_to change(Task, :count)
      end

      it 'redirects to new task path' do
        post :create, params: { task: attributes_for(:task, title: nil) }
        expect(response).to redirect_to(new_task_path)
        expect(flash[:alert]).to include("Что-то пошло не так:")
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested task to @task' do
      get :edit, params: { id: task.id }
      expect(assigns(:task)).to eq(task)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the requested task' do
        patch :update, params: { id: task.id, task: { title: 'New Title' } }
        task.reload
        expect(task.title).to eq('New Title')
      end

      it 'redirects to the tasks path' do
        patch :update, params: { id: task.id, task: { title: 'New Title' } }
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to eq('Задача была обновлена.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the task' do
        patch :update, params: { id: task.id, task: { title: nil } }
        task.reload
        expect(task.title).not_to be_nil
      end

      it 'redirects to the edit task path' do
        patch :update, params: { id: task.id, task: { title: nil } }
        expect(response).to redirect_to(edit_task_path(task))
        expect(flash[:alert]).to include("Что-то пошло не так:")
      end
    end
  end

  describe 'DELETE #delete' do
    it 'deletes the task' do
      task_to_delete = create(:task, user: user)
      expect {
        delete :delete, params: { id: task_to_delete.id }
      }.to change(Task, :count).by(-1)
    end

    it 'redirects to the tasks path' do
      delete :delete, params: { id: task.id }
      expect(response).to redirect_to(tasks_path)
      expect(flash[:notice]).to eq('Задача успешно удалена!')
    end
  end
end
