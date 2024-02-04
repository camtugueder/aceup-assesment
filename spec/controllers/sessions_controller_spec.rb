require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new session' do
        expect {
          post :create, params: { session: attributes_for(:session) }
        }.to change(Session, :count).by(1)
      end

      it 'returns status code 201' do
        post :create, params: { session: attributes_for(:session) }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { attributes_for(:session, coach_hash_id: nil) }

      it 'does not create a new session' do
        expect {
          post :create, params: { session: invalid_attributes }
        }.not_to change(Session, :count)
      end

      it 'returns status code 422' do
        post :create, params: { session: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Coach hash can't be blank")
      end

      it 'does not allow creating a session with an invalid duration' do
        invalid_attributes = attributes_for(:session, duration: -10)
        post :create, params: { session: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include('Duration must be greater than 0')
      end

      it 'does not allow creating a session with overlapping times for the same coach' do
        start_time_for_first_session = DateTime.now.tomorrow
        create(:session, coach_hash_id: 'same_coach', start: start_time_for_first_session, duration: 60)
        start_time_for_overlapping_session = start_time_for_first_session + 30.minutes
        overlapping_attributes = attributes_for(:session, coach_hash_id: 'same_coach', start: start_time_for_overlapping_session, duration: 30)
        post :create, params: { session: overlapping_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include('The coach has an overlapping session')
      end
    end
  end
end