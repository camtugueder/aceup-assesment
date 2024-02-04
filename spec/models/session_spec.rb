require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'validations' do
    subject { build(:session) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    context 'coach_hash_id' do
      it 'is not valid with an empty coach_hash_id' do
        subject.coach_hash_id = ''
        expect(subject).not_to be_valid
      end

      it 'is not valid without a coach_hash_id' do
        subject.coach_hash_id = nil
        expect(subject).not_to be_valid
      end
    end

    context 'client_hash_id' do
      it 'is not valid without a client_hash_id' do
        subject.client_hash_id = nil
        expect(subject).not_to be_valid
      end

      it 'is not valid with an empty client_hash_id' do
        subject.client_hash_id = ''
        expect(subject).not_to be_valid
      end
    end

    context 'start time' do
      it 'is not valid without a start' do
        subject.start = nil
        expect(subject).not_to be_valid
      end

      it 'is not valid with a start time in the past' do
        subject.start = 1.hour.ago
        expect(subject).not_to be_valid
        expect(subject.errors[:start]).to include("can't be in the past")
      end

      it 'is valid with a future start time' do
        subject.start = 1.hour.from_now
        expect(subject).to be_valid
      end
    end

    context 'duration' do
      it 'is not valid without a duration' do
        subject.duration = nil
        expect(subject).not_to be_valid
      end

      it 'is not valid with a non-numeric duration' do
        subject.duration = 'abc'
        expect(subject).not_to be_valid
      end

      it 'is not valid with a negative duration' do
        subject.duration = -1
        expect(subject).not_to be_valid
      end

      it 'is not valid with a zero duration' do
        subject.duration = 0
        expect(subject).not_to be_valid
      end
    end

    context 'overlapping sessions' do
      let!(:existing_session) { create(:session, coach_hash_id: 'coach1', start: 1.hour.from_now, duration: 60) }

      it 'is not valid with overlapping sessions for the same coach' do
        new_session = build(:session, coach_hash_id: 'coach1', start: 1.5.hours.from_now, duration: 60)
        expect(new_session).not_to be_valid
        expect(new_session.errors[:base]).to include('The coach has an overlapping session')
      end

      it 'is valid with non-overlapping sessions for the same coach' do
        new_session = build(:session, coach_hash_id: 'coach1', start: 2.hours.from_now, duration: 60)
        expect(new_session).to be_valid
      end

      it 'is valid with sessions for different coaches' do
        new_session = build(:session, coach_hash_id: 'coach2', start: 1.hour.from_now, duration: 60)
        expect(new_session).to be_valid
      end
    end
  end
end
