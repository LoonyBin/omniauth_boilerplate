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

    def self.find_by(authentication_id)
      new(authentication: Authentication.find(authentication_id))
    end
  end
end
