# frozen_string_literal: true

class GithubRepositorySearch
  include Concurrent::Async
  include Github

  check :github_api_key_exists
  try :search, catch: SocketError
  try :persist_repositories, catch: ActiveRecord::ActiveRecordError

  default_params per_page: 100

  private

  def github_api_key_exists
    !ENV["GITHUB_API_KEY"].nil?
  end

  def search(url)
    next_pattern = /(?<=<)([\S]*)(?=>; rel="Next")/i
    pages_remaining = true
    attrs_ary = []

    while pages_remaining
      response = self.class.get(url)
      model_attrs = map_repo_json_to_model_attrs(response)
      attrs_ary.push(*model_attrs)
      Rails.logger.info "Received #{attrs_ary.size} / #{response['total_count']} repositories from Github API"

      link_header = response.headers["link"]
      pages_remaining = link_header&.include?("rel=\"next\"")
      if pages_remaining
        url = next_pattern.match(link_header)[0]
      end
    end

    attrs_ary
  end

  def map_repo_json_to_model_attrs(response)
    response["items"].each_with_object([]) do |item, ary|
      ary << {
        owner: item.dig("owner", "login"),
        name: item["name"],
        url: item["html_url"],
        stargazers_count: item["stargazers_count"],
      }
    end
  end

  def persist_repositories(attrs_ary)
    # Using upsert_all here because it's fast, and validation is limited on the
    # model, so it's ok if we skip it
    GithubRepository.upsert_all(attrs_ary, unique_by: %i[owner name]) # rubocop:disable Rails/SkipsModelValidations
  end
end
