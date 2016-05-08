module Omniauth
  module Boilerplate
    class Engine < ::Rails::Engine
      isolate_namespace Omniauth::Boilerplate
    end
  end
end
