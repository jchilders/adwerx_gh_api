class GithubRepository < ApplicationRecord
  validates_presence_of :name, :owner
end
