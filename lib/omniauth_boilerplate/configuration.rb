module OmniauthBoilerplate
  class Configuration
    # The default path OmniauthBoilerplate will redirect signed in users to.
    # Defaults to `"/"`. This can often be overridden for specific scenarios by
    # overriding controller methods that rely on it.
    # @return [String]
    attr_accessor :redirect_url

    # The ActiveRecord class name that represents users in your application.
    # Defualts to `'::User'`.
    # @return [String]
    attr_accessor :user_model_name

    def initialize
      @redirect_url = '/'
      @user_model_name = '::User'
    end

    def user_model
      @user_model ||= @user_model_name.constantize
    end
  end

  # @return [OmniauthBoilerplate::Configuration] OmniauthBoilerplate's current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Set OmniauthBoilerplate's configuration
  # @param config [OmniauthBoilerplate::Configuration]
  def self.configuration=(config)
    @configuration = config
  end

  # Modify OmniauthBoilerplate's current configuration
  # @yieldparam [OmniauthBoilerplate::Configuration] config current OmniauthBoilerplate config
  # ```
  # OmniauthBoilerplate.configure do |config|
  #   config.routes = false
  # end
  # ```
  def self.configure
    yield configuration
  end
end
