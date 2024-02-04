class Session < ApplicationRecord
  validates :coach_hash_id, presence: true, length: { minimum: 1 }
  validates :client_hash_id, presence: true, length: { minimum: 1 }
  validates :start, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validate :validate_non_overlapping_sessions
  validate :start_time_cannot_be_in_the_past

  def self.overlapping_condition
    case ActiveRecord::Base.connection.adapter_name
    when 'SQLite'
      'datetime(start, duration || \' minutes\')'
    when 'PostgreSQL'
      'start + INTERVAL \'1 MINUTE\' * duration'
    else
      raise 'Unsupported database adapter'
    end
  end

  scope :for_coach, ->(coach_id) { where(coach_hash_id: coach_id) }
  scope :excluding_self, ->(id) { where.not(id: id) }
  scope :overlapping, ->(start_time, end_time) do
    where("start < :end_time AND :start_time < #{overlapping_condition}", start_time: start_time, end_time: end_time)
  end

  private

  def start_time_cannot_be_in_the_past
    if start.present? && start < Time.current
      errors.add(:start, "can't be in the past")
    end
  end

  def validate_non_overlapping_sessions
    return if start.nil? || duration.nil?
    scope = Session.for_coach(coach_hash_id)
    scope = scope.excluding_self(id) if persisted?
    if scope.overlapping(start, end_time_of_current_session).exists?
      errors.add(:base, 'The coach has an overlapping session')
    end
  end

  def end_time_of_current_session
    start + duration.minutes
  end
end
