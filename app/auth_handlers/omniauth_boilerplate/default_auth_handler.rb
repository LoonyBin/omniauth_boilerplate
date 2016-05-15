module OmniauthBoilerplate
  # Providers provide functionality per omniauth provider
  class DefaultAuthHandler
    def initialize(opts={})
      @authentication = opts[:authentication]
      @omniauth = opts[:omniauth]
    end

    def meta
      @omniauth
    end

    def user_attr
      Hash.new
    end

    def self.find_by(authentication_id)
      new(authentication: Authentication.find(authentication_id))
    end

    # Hooks for common authentication actions
    def after_create; end
    def after_update; end
    def after_destroy; end
    def after_sign_in; end
    def after_sign_out; end
    def after_sign_up; end
  end
end
