require_relative '../restful_api'
require_relative 'restful_api/helpers'
require_relative 'restful_api/routes'

module Sinatra
  module RestfulApi
    def self.registered(app)
      app.helpers Helpers
    end

    def restful_api(name, &block)
      Routes.draw(name, self, &block)
    end
  end

  register RestfulApi
end
