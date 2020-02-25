class ApplicationController < ActionController::Base
  private

    def render_unprocessable_entity! entity
      render json: entity.errors.full_messages, status: 422
    end
end
