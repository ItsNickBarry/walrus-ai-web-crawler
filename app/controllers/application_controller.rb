class ApplicationController < ActionController::Base
  layout :layout_by_resource

  private

    def render_forbidden!
      render json: ["Your account does not have access to the requested resource."], status: 403
    end

    def render_unprocessable_entity! entity
      render json: entity.errors.full_messages, status: 422
    end

    def layout_by_resource
      if devise_controller?
        'devise'
      else
        'application'
      end
    end
end
