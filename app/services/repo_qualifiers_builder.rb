# frozen_string_literal: true

# Helper to build the request querystring required by the GitHub repository search API endpoint.
#
# Example uses:
#
# Use defaults:
#
#   > RepoQualifiersBuilder.new.build
#    => "fork:false stars:1..2000 pushed:>2023-03-15 language:ruby language:javascript"
#
# Use defaults, but convert to HTTP querystring:
#
#   > RepoQualifiersBuilder.new.to_params
#    => "q=fork%3Afalse%20stars%3A1..2000%20pushed%3A%3E2023-03-15%20language%3Aruby%20language%3Ajavascript"
#
# Get forked repos with five stars:
#
#   > RepoQualifiersBuilder.new.fork(true).stars(5).build
#    => "fork:true stars:5"
#
# @see https://docs.github.com/en/search-github/searching-on-github/searching-for-repositories
class RepoQualifiersBuilder
  attr_accessor :qualifiers

  def initialize
    @qualifiers = []
  end

  def build
    defaults if @qualifiers.none?

    @qualifiers.join(" ")
  end

  def forked(include_forks = false)
    @qualifiers << "fork:#{include_forks}"
    self
  end

  def language(lang)
    @qualifiers << "language:#{lang}"
    self
  end

  def stars(stargazers_count = "1..2000")
    @qualifiers << "stars:#{stargazers_count}"
    self
  end

  def license(license_keyword)
    @qualifiers << "license:#{license_keyword}"
    self
  end

  def to_params
    HTTParty::HashConversions.to_params({ q: build })
  end

  def updated(pushed_at = Date.yesterday)
    @qualifiers << "pushed:>#{pushed_at.to_fs(:iso8601)}"
    self
  end

  private def defaults
    forked
      .stars
      .updated
      .language("ruby").language("javascript")
      .license("apache-2.0").license("gpl")
      .license("lgpl").license("mit")
  end
end
