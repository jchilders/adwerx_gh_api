# frozen_string_literal: true

module HttpService
  class << self
    def included(base)
      base.class_eval do
        include(Dry::Transaction)
        include(HTTParty)

        headers "Content-Type": "application/json"

        # debug_output($stdout) if Rails.env.development?

        private def response_ok?(response)
          response.ok?
        end
      end
    end
  end
end
