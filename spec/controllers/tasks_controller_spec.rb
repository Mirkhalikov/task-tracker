require 'rails_helper'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

RSpec.describe TasksController, type: :controller do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns @tasks and @users' do
      get :index
      expect(assigns(:tasks)).to eq([ task ])
      expect(assigns(:users)).to eq([ user ])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested task to @task' do
      get :show, params: { id: task.id }
      expect(assigns(:task)).to eq(task)
    end

    it 'renders the show template' do
      get :show, params: { id: task.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new task to @task' do
      get :new
      expect(assigns(:task)).to be_a_new(Task)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) { { title: "New Task", description: "Task Description" } }

      it 'creates a new task' do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it 'redirects to the tasks path with a notice' do
        post :create, params: { task: valid_attributes }
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to eq("Задача была создана.")
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { title: "" } }

      it 'does not create a new task' do
        expect {
          post :create, params: { task: invalid_attributes }
        }.not_to change(Task, :count)
      end

      it 'redirects to the new task path with an alert' do
        post :create, params: { task: invalid_attributes }
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

    it 'renders the edit template' do
      get :edit, params: { id: task.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:valid_attributes) { { title: "Updated Task" } }

      it 'updates the requested task' do
        patch :update, params: { id: task.id, task: valid_attributes }
        task.reload
        expect(task.title).to eq("Updated Task")
      end

      it 'redirects to the tasks path with a notice' do
        patch :update, params: { id: task.id, task: valid_attributes }
        expect(response).to redirect_to(tasks_path)
        expect(flash[:notice]).to eq("Задача была обновлена.")
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { title: "" } }

      it 'does not update the task' do
        patch :update, params: { id: task.id, task: invalid_attributes }
        task.reload
        expect(task.title).not_to eq("")
      end

      it 'redirects to the edit task path with an alert' do
        patch :update, params: { id: task.id, task: invalid_attributes }
        expect(response).to redirect_to(edit_task_path(task))
        expect(flash[:alert]).to include("Что-то пошло не так:")
      end
    end
  end

  describe 'DELETE #delete' do
    it 'deletes the task' do
      task = FactoryBot.create(:task, user: user)
      expect {
        delete :delete, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end

    it 'redirects to the tasks path with a notice' do
      delete :delete, params: { id: task.id }
      expect(response).to redirect_to(tasks_path)
      expect(flash[:notice]).to eq("Задача успешно удалена!")
    end
  end
end
