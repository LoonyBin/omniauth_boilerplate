module OmniauthBoilerplate
  class Authentication < ActiveRecord::Base
    belongs_to :user, class_name: OmniauthBoilerplate.configuration.user_model_name

    validates_associated :user

    def self.find_with_omniauth(auth)
      find_by(uid: auth['uid'], provider: auth['provider'])
    end

    def self.create_with_omniauth(auth)
      create(uid: auth['uid'], provider: auth['provider'])
    end

    def update_with_omniauth(auth)
      update(meta: auth)
    end
  end
end
