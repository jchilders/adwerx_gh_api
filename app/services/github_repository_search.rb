# frozen_string_literal: true

class GithubRepositorySearch
  include Github

  try :search, catch: SocketError
  try :persist_repositories, catch: ActiveRecord::ActiveRecordError

  default_params per_page: 100

  private

  def search(url)
    next_pattern = /(?<=<)([\S]*)(?=>; rel="Next")/i
    pages_remaining = true
    attrs_ary = []

    while pages_remaining
      response = self.class.get(url)
      model_attrs = map_repo_json_to_model_attrs(response)
      attrs_ary.push(*model_attrs)

      link_header = response.headers["link"]
      # The GH API stops returning "next" pages after 1000 items have been
      # returned... Unsure why.
      pages_remaining = link_header && link_header.include?("rel=\"next\"")
      if pages_remaining
        url = next_pattern.match(link_header)[0]
      end
    end

    attrs_ary
  end

  def map_repo_json_to_model_attrs(response)
    response["items"].each_with_object([]) do |item, ary|
      ary << {
        owner: item.dig("owner","login"),
        name: item["name"],
        url: item["url"],
        stargazers_count: item["stargazers_count"]
      }
    end
  end

  def persist_repositories(attrs_ary)
    GithubRepository.upsert_all(attrs_ary, unique_by: %i[owner name])
  end
end
