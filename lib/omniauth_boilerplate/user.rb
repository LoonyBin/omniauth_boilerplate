module OmniauthBoilerplate
  # Include in the user model to load boilerplate
  module User
    extend ActiveSupport::Concern

    included do
      has_many :authentications, class_name: 'OmniauthBoilerplate::Authentication'
    end
  end
end
