require 'rails_helper'

describe EventsController do
  let(:user) { create(:user) }
  let(:second_user) { create(:second_user) }
  let(:event) { create(:today_event) }

  describe 'authorized user' do
    before do
      sign_in(user)
    end

    describe 'GET index' do
      it 'responds successfully with an HTTP 200 status code' do
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template('index')
        expect(assigns(:events)).to eq(user.events)
      end
    end

    describe 'GET show' do
      it 'responds successfully with an HTTP 200 status code' do
        get :show, params: { id: event.id }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'renders the show template' do
        get :show, params: { id: event.id }
        expect(response).to render_template('show')
        expect(assigns(:event)).to eq(event)
      end
    end

    describe 'GET new' do
      it 'responds successfully with an HTTP 200 status code' do
        get :new
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'renders the new template' do
        get :new
        expect(response).to render_template('new')
        expect(assigns(:event)).to be_a_new(Event)
      end
    end

    describe 'GET edit' do
      before do
        event
      end

      it 'responds successfully with an HTTP 200 status code' do
        get :edit, params: { id: event }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'renders the edit template' do
        get :edit,  params: { id: event }
        expect(response).to render_template('edit')
        expect(assigns(:event)).to eq(event)
      end
    end

    describe 'POST create' do
      subject { post :create, params: { event: attributes_for(:today_event) } }

      it 'creates a new Event' do
        expect{subject}.to change(Event,:count).by(1)
      end

      it 'redirects to the @event' do
        post :create, params: { event: attributes_for(:today_event) }
        expect(response).to redirect_to Event.last
      end
    end

    describe 'PUT update' do
      before do
        event
      end

      it 'updates attributes' do
        put :update, params: { id: event,
                               event: attributes_for(:visited_event) }
        event.reload
        expect(event.name).to have_text('Visited event')
        expect(event.visited_flag).to eq(true)
      end

      it 'redirects to the updated event' do
        put :update, params: { id: event,
                               event: attributes_for(:visited_event) }
        expect(response).to redirect_to Event.last
      end
    end

    describe 'DELETE destroy' do
      before do
        event
      end
      subject { delete :destroy, params: { id: event } }

      it 'deletes the event' do
        expect{subject}.to change(Event,:count).by(-1)
      end

      it 'redirects to events_url' do
        delete :destroy, params: { id: event }
        expect(response).to redirect_to events_url
      end
    end

    describe 'GET users' do
      it 'responds successfully with an HTTP 200 status code' do
        get :users, params: { id: event }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'renders the users template' do
        get :users, params: { id: event }
        expect(response).to render_template('users')
        expect(assigns(:event)).to eq(event)
        expect(assigns(:users)).to eq(event.users)
        expect(assigns(:all_users_except_current)).to eq(User.where.not(id: user.id))
      end
    end

    describe 'PUT update_users' do
      before do
        event
      end

      it 'updates attributes' do
        put :update_users, params: { id: event, users: [second_user.id] }
        event.reload
        expect(event.users).to eq([user, second_user])
      end

      it 'redirects to the updated event' do
        put :update_users, params: { id: event, users: [second_user.id] }
        expect(response).to redirect_to users_path(event)
      end
    end
  end

  describe 'unauthorized user' do
    describe 'GET index' do
      it 'responds 302 status code' do
        get :index
        expect(response).to have_http_status(302)
      end
    end

    describe 'GET show' do
      it 'responds 302 status code' do
        get :show, params: { id: event.id }
        expect(response).to have_http_status(302)
      end
    end

    describe 'GET new' do
      it 'responds 302 status code' do
        get :new
        expect(response).to have_http_status(302)
      end
    end

    describe 'GET edit' do
      it 'responds 302 status code' do
        get :edit, params: { id: event.id }
        expect(response).to have_http_status(302)
      end
    end

    describe 'POST create' do
      it 'responds 302 status code' do
        post :create, params: { name: 'test', date: Date.today }
        expect(response).to have_http_status(302)
      end
    end

    describe 'PUT update' do
      it 'responds 302 status code' do
        put :update, params: { name: 'test', date: Date.today, id: event.id }
        expect(response).to have_http_status(302)
      end
    end

    describe 'DELETE destroy' do
      it 'responds 302 status code' do
        delete :destroy, params: { id: event.id }
        expect(response).to have_http_status(302)
      end
    end

    describe 'DELETE destroy' do
      it 'responds 302 status code' do
        delete :destroy, params: { id: event.id }
        expect(response).to have_http_status(302)
      end
    end

    describe 'GET users' do
      it 'responds 302 status code' do
        get :users, params: { id: event.id }
        expect(response).to have_http_status(302)
      end
    end

    describe 'GET users' do
      it 'responds 302 status code' do
        get :users, params: { id: event.id }
        expect(response).to have_http_status(302)
      end
    end

    describe 'PUT update_users' do
      it 'responds 302 status code' do
        put :update_users, params: { id: event.id, users: [user.id] }
        expect(response).to have_http_status(302)
      end
    end
  end
end
