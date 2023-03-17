# frozen_string_literal: true

module Github
  class << self
    def included(base)
      base.class_eval do
        include HttpService

        # base_uri "https://api.github.com"

        headers "Accept": "application/vnd.github+json"
        headers "X-GitHub-Api-Version": "2022-11-28"
        headers "Authorization": "Bearer #{ENV['GITHUB_API_KEY']}"
      end
    end
  end
end
