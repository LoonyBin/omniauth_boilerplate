require_dependency 'omniauth_boilerplate/base_controller'

module OmniauthBoilerplate
  # AuthenticationsController takes care of signin/signup/linking of omniauth authentications
  class AuthenticationsController < BaseController
    before_action :set_authentication, only: [:destroy]

    # GET /authentications
    def index
      @authentications = current_user.authentications
    end

    # GET /authentications/new
    def new
    end

    # GET /auth/:provider/callback
    # POST /auth/:provider/callback
    def create
      auth = request.env['omniauth.auth']

      find_or_create_authentication_with auth

      if signed_in?
        assign_authentication_to_current_user
      elsif @authentication.user.present?
        # The authentication we found had a user associated with it so let's
        # just log them in here
        sign_in @authentication.user
        redirect_to OmniauthBoilerplate.configuration.redirect_url, notice: t('authentications.signed_in')
      else
        # No user associated with the authentication so we need to create a new one
        signup(auth)
      end
    end

    # DELETE /authentications/1
    def destroy
      current_user.authentications.destroy(params[:id])
      redirect_to authentications_url, notice: t('authentications.destroy')
    end

    private

    def find_or_create_authentication_with(auth)
      # Find an authentication here
      @authentication = Authentication.find_with_omniauth(auth)
      if @authentication.nil?
        # If no authentication was found, create a brand new one here
        @authentication = Authentication.create_with_omniauth(auth)
      end

      @authentication.update_with_omniauth(auth)
    end

    def assign_authentication_to_current_user
      if @authentication.user.present?
        # User is signed in so they are trying to link an authentication with their
        # account.
        merge_users
      else
        # The authentication is not associated with any user so let's try to
        # associate the authentication with current_user
        link_authentication
      end
    end

    def merge_users
      if @authentication.user == current_user
        # The current user is already associated with the authentication.
        # So let's display an error message.
        redirect_to OmniauthBoilerplate.configuration.redirect_url, notice: t('authentications.already_linked')
      elsif current_user.respond_to? :merge_with
        # The user associated with the authentication is not the current user.
        # But the User model supports merging the accounts so let's try
        # to do that.
        if current_user.merge_with(@authentication.user)
          redirect_to OmniauthBoilerplate.configuration.redirect_url, notice: t('authentications.merge_success')
        else
          redirect_to OmniauthBoilerplate.configuration.redirect_url, alert: t('authentications.merge_failure')
        end
      else
        # The user associated with the authentication is not the current user.
        # And the User model does not support merging the accounts so
        # let's display an error message.
        redirect_to OmniauthBoilerplate.configuration.redirect_url, notice: t('authentications.merge_unsupported')
      end
    end

    def link_authentication
      @authentication.user = current_user
      if @authentication.save
        redirect_to OmniauthBoilerplate.configuration.redirect_url, notice: t('authentications.link_success')
      else
        redirect_to OmniauthBoilerplate.configuration.redirect_url, alert: t('authentications.link_failure')
      end
    end

    def signup(auth)
      @authentication.user = if OmniauthBoilerplate.configuration.user_model.respond_to? :create_with_omniauth
                               OmniauthBoilerplate.configuration.user_model.create_with_omniauth(auth)
                             else
                               OmniauthBoilerplate.configuration.user_model.create
                             end

      if @authentication.save
        redirect_to OmniauthBoilerplate.configuration.redirect_url, notice: t('authentications.signup_success')
      else
        redirect_to OmniauthBoilerplate.configuration.redirect_url, alert: t('authentications.signup_failure')
      end
    end
  end
end
