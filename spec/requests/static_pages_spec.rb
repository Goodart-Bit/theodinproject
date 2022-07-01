require 'rails_helper'

RSpec.describe 'Static Pages', type: :request do
  describe 'GET #home' do
    it 'renders the home page' do
      get home_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #about' do
    it 'renders the about page' do
      get about_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #terms_of_use' do
    it 'renders the terms of use page' do
      get terms_of_use_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #success stories' do
    it 'renders the success stories page' do
      get success_stories_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #import_lessons' do
    context 'when logged in as an admin' do
      let(:user) { create(:user, admin: true) }

      it 'fires the import job and redirects to the home page' do
        allow(UpdateLessonContentJob).to receive(:perform_async)

        sign_in(user)
        post import_content_path

        expect(response).to redirect_to(root_path)
        expect(UpdateLessonContentJob).to have_received(:perform_async)
      end
    end

    context 'when logged in but not an admin' do
      let(:user) { create(:user) }

      it 'does not fire the import job then redirects to the home page' do
        allow(UpdateLessonContentJob).to receive(:perform_async)

        sign_in(user)
        post import_content_path

        expect(response).to redirect_to(root_path)
        expect(UpdateLessonContentJob).not_to have_received(:perform_async)
      end
    end
  end
end
