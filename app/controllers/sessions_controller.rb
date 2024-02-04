# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    session = Session.new(session_params)
    if session.save
      render json: session, status: :created
    else
      render json: { errors: session.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def session_params
    params.require(:session).permit(:coach_hash_id, :client_hash_id, :start, :duration)
  end
end
