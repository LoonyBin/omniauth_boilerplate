module OmniauthBoilerplate
  # Include in the ApplicationController or <Resource>Controller
  module Controller
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :signed_in?
    end

    protected

    def current_user
      @current_user ||= OmniauthBoilerplate.configuration.user_model.find_by(id: session[:user_id])
    end

    def signed_in?
      !!current_user
    end

    def sign_in(user)
      @current_user = user
      session[:user_id] = user.nil? ? nil : user.id
    end
  end
end
